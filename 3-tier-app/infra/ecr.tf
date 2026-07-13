# create ecr repository for backend

resource "aws_ecr_repository" "backend" {
  name = "${var.prefix}-backend"
}

# 292659698930.dkr.ecr.us-east-1.amazonaws.com/3tier-devopsdozo-backend
# create ecr repository for frontend

resource "aws_ecr_repository" "frontend" {
  name = "${var.prefix}-frontend"
}
# 292659698930.dkr.ecr.us-east-1.amazonaws.com/3tier-devopsdozo-frontend