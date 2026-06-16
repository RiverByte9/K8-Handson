repo : 879381241087.dkr.ecr.ap-south-1.amazonaws.com/kind-static-app


docker build -t kindapp .

docker tag kindapp 292659698930.dkr.ecr.ap-south-1.amazonaws.com/kind-static-app:1.0


docker push 292659698930.dkr.ecr.ap-south-1.amazonaws.com/kind-static-app:1.0

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 292659698930.dkr.ecr.ap-south-1.amazonaws.com



# when useing cer with kind

<!-- kubectl create secret <type_of_secret> <secret-name> -->
kubectl create secret docker-registry ecr-secret \
  --docker-server=292659698930.dkr.ecr.ap-south-1.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region ap-south-1) \
  --namespace=default



 kubectl get secret ecr-secret -o jsonpath='{.data.\.dockerconfigjson}'

 $ kubectl get secret ecr-secret -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode
 $ kubectl get secret ecr-secret -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode | jq


 $ echo '{"auths":{"registry-url":{"username":"AWS","password":"TOKEN"}}}' | base64
 echo "ey9fQo=" | base64 --decode

 {"auths":{"registry-url":{"username":"AWS","password":"TOKEN"}}}

<!-- apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-deployment
  labels:
    app: flask
spec:
  replicas: 3
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      imagePullSecrets:
        - name: ecr-secret # secret name
      containers:
      - name: app
        image: 292659698930.dkr.ecr.ap-south-1.amazonaws.com/kind-static-app:1.0
         # Always, Never, IfNotPresent
        imagePullPolicy: Always # default is IfNotPresent 
        ports:
        - containerPort: 5000 -->


Annotations:      <none>
Status:           Running
IP:               10.244.0.10
IPs:
  IP:           10.244.0.10
Controlled By:  ReplicaSet/nginx-deployment-96b9d695
Containers:
  nginx:
    Container ID:   containerd://0a961471c70c61f646ff8200bc607c1e75ba71b55a6e9cbe524ab5574a2027d8
    Image:          nginx:latest
    Image ID:       docker.io/library/nginx@sha256:5aca99593157f4ae539a5dec1092a0ad8762f8e2eb1789085a13a0f5622369f6
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 28 May 2026 11:44:07 +0530
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-h7wgs (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-h7wgs:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  16m   default-scheduler  Successfully assigned default/nginx-deployment-96b9d695-5gfrn to kind-control-plane
  Normal  Pulling    16m   kubelet            Pulling image "nginx:latest"
  Normal  Pulled     16m   kubelet            Successfully pulled image "nginx:latest" in 1.624s (1.624s including waiting). Image size: 63120520 bytes.
  Normal  Created    16m   kubelet            Created container: nginx
  Normal  Started    16m   kubelet            Started container nginx
PS D:\K8-Handson\Day-1> history                                             

  Id CommandLine                                                                                                                            
  -- -----------                                                                                                                            
   1 try { . "e:\Prog\Microsoft VS Code\f6cfa2ea24\resources\app\out\vs\workbench\contrib\terminal\common\scripts\shellIntegration.ps1" }...
   2 kind get cluster                                                                                                                       
   3 minikube start                                                                                                                         
   4 kind get clusters                                                                                                                      
   5 kind create cluster                                                                                                                    
   6 kind get clusters                                                                                                                      
   7 kubecrl get pods                                                                                                                       
   8 kubectl get pods                                                                                                                       
   9 kubectl get namespace                                                                                                                  
  10 kubectl get pod -a                                                                                                                     
  11 kubectl get pod -A                                                                                                                     
  12 kubectl get pod -n kubesystem                                                                                                          
  13 kubectl get pod -n kube-system                                                                                                         
  14 kubectl create -f pod.yaml                                                                                                             
  15 cd Day-1                                                                                                                               
  16 kubectl create -f pod.yaml                                                                                                             
  17 kubectl get po                                                                                                                         
  18 kubectl get po                                                                                                                         
  19 kubectl describe pod nginx                                                                                                             
  20 kubectl logs nginx                                                                                                                     
  21 kubectl get po                                                                                                                         
  22 kubectl get pod -o wide                                                                                                                
  23 kubectl delete pod nginx                                                                                                               
  24 kubectl get pod                                                                                                                        
  25 kubectl apply -f pod.yaml                                                                                                              
  26 kubectl get pod                                                                                                                        
  27 clear                                                                                                                                  
  28 kubectl apply -f deployment.yaml                                                                                                       
  29 kubectl get deploy                                                                                                                     
  30 kubectl get dep                                                                                                                        
  31 kubectl get pod                                                                                                                        
  32 kubectl delete pod nginx-deployment-96b9d695-946m2                                                                                     
  33 kubectl get pod                                                                                                                        
  34 kubectl delete pod nginx                                                                                                               
  35 kubectl get pod                                                                                                                        
  36 kubectl delete pod nginx-deployment -96b9d695-9bvnc                                                                                    
  37 kubectl delete pod nginx-deployment-96b9d695-9bvnc                                                                                     
  38 kubectl get pod                                                                                                                        
  39 kubectl get pod -w                                                                                                                     
  40 clear                                                                                                                                  
  41 kubectl apply -f service.yaml                                                                                                          
  42 kubectl get service -o wide                                                                                                            
  43 kubectl port-forward service/nginx-service 8800:8080                                                                                   
  44 kubectl get pod                                                                                                                        
  45 kubectl describe pod nginx-deployment-96b9d695-5gfrn                                                                                   


PS D:\K8-Handson\Day-1> 
 *  History restored 
