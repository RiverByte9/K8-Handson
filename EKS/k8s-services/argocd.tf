# helm resource for argocd

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.16"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name

  set = [
    {  
      name  = "server.service.type"
      value = "ClusterIP"
    },
    {
      name  = "configs.params.server\\.insecure"
      value = "true"
    }
  ]
}

# argocd ingress -> access argocd on a subdomain -> argocd.devopsdozo.livingdevops.org

resource "kubernetes_ingress_v1" "argocd_ingress_tls" {
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"

    annotations = {
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"

      "alb.ingress.kubernetes.io/listen-ports"        = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/ssl-redirect"        = "443"
      "alb.ingress.kubernetes.io/certificate-arn"     = aws_acm_certificate.argocd_cert.arn

      "alb.ingress.kubernetes.io/healthcheck-path"     = "/"
      "alb.ingress.kubernetes.io/healthcheck-protocol" = "HTTP"

      "alb.ingress.kubernetes.io/load-balancer-attributes" = "idle_timeout.timeout_seconds=60"

      "alb.ingress.kubernetes.io/tags" = "Environment=production,ManagedBy=Terraform,Name=${var.app_subdomain}-ingress"

      "alb.ingress.kubernetes.io/group.name" = "devopsdozo"
    }
  }

  depends_on = [
    kubernetes_namespace_v1.argocd,
    aws_acm_certificate_validation.app,
    helm_release.argocd
  ]

  spec {
    ingress_class_name = "alb"

    rule {
      host = "argocd.${var.app_subdomain}.${var.domain_name}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# ACM and Route53 record for argocd.devopsdozo.livingdevops.org

# Pull the public hosted zone id from Route53
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# Create the ACM certificate
resource "aws_acm_certificate" "argocd_cert" {
  domain_name       = "argocd.${var.app_subdomain}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "argocd-cert"
  }
}

# Create Route53 record for ACM certificate validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.argocd_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# Validate the ACM certificate
resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = aws_acm_certificate.argocd_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Wait for ALB to assign hostname to the Ingress
resource "time_sleep" "wait_for_argocd_alb" {
  depends_on      = [kubernetes_ingress_v1.argocd_ingress_tls]
  create_duration = "120s"
}

# Create Route53 alias record to point subdomain to ALB
resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "argocd.${var.app_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress_v1.argocd_ingress_tls.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = true
  }

  depends_on = [time_sleep.wait_for_argocd_alb]
}