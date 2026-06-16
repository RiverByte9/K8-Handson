# Postgres as a Deployment (comparison only)

Runs Postgres 15 as a single-replica **Deployment** with a **PersistentVolumeClaim**.

> **Use `../db-as-statefulset/` instead** for Day 3–4. Deployments can reschedule pods to different nodes — fine for learning, not ideal for databases.

## Apply

```bash
kubectl apply -f secret.yaml
kubectl apply -f pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Or:

```bash
kubectl apply -f .
```

## Verify

```bash
kubectl get pods -l app=postgres
kubectl get svc postgres
kubectl exec -it deploy/postgres -- pg_isready -U postgres -d mydb
```

## Point the app at this database

The Service name is **`postgres`** on port **5432** (same namespace).

```text
DB_LINK=postgresql://postgres:password@postgres:5432/mydb
```

| Scenario | `DB_LINK` host |
|----------|----------------|
| App in **same namespace** | `postgres` |
| App in **another namespace** (`app-ns`) | `postgres.<db-namespace>.svc.cluster.local` |
| Full DNS | `postgres.<namespace>.svc.cluster.local` |

Example app Secret (`k8s/main/secret.yaml`):

```yaml
stringData:
  DB_LINK: postgresql://postgres:password@postgres:5432/mydb
```

Apply the app secret **after** Postgres is ready:

```bash
kubectl wait --for=condition=available deployment/postgres --timeout=120s
kubectl apply -f ../main/secret.yaml
kubectl apply -f ../main/deployment-probes.yaml   # or any app manifest
```

Credentials must match `secret.yaml` in this folder (`POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`).




# postgres link will loo like
postgresql://<username>:<password>@<db_host>/<db_name>


# output

PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get storageclass                           
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  43h
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f pvc.yaml
persistentvolumeclaim/postgres-data created
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pvc          
NAME            STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Pending                                      standard       <unset>                 7s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pv
No resources found
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl delete deployment postgres --ignore-not-found
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl delete pvc postgres-data --ignore-not-found
persistentvolumeclaim "postgres-data" deleted
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> 

PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f deployment.yaml
deployment.apps/postgres created
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pods
>> 
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-gqvgn   0/1     Pending   0          11s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl describe pod -l app=postgres
Name:             postgres-69dcdb8955-gqvgn
Namespace:        default
Priority:         0
Service Account:  default
Node:             <none>
Labels:           app=postgres
                  pod-template-hash=69dcdb8955
Annotations:      <none>
Status:           Pending
IP:               
IPs:              <none>
Controlled By:    ReplicaSet/postgres-69dcdb8955
Containers:
  postgres:
    Image:      postgres:15
    Port:       5432/TCP
    Host Port:  0/TCP
    Liveness:   exec [pg_isready -U postgres -d mydb] delay=30s timeout=1s period=20s #success=1 #failure=3
    Readiness:  exec [pg_isready -U postgres -d mydb] delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:
      random-env-variable:  random-value
      POSTGRES_USER:        <set to the key 'POSTGRES_USER' in secret 'postgres-secret'>      Optional: false
      POSTGRES_PASSWORD:    <set to the key 'POSTGRES_PASSWORD' in secret 'postgres-secret'>  Optional: false
      POSTGRES_DB:          <set to the key 'POSTGRES_DB' in secret 'postgres-secret'>        Optional: false
      PGDATA:               /var/lib/postgresql/data/pgdata
    Mounts:
      /var/lib/postgresql/data from postgres-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-wv7rb (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-wv7rb:
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
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  21s   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> 

===================

PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f pvc.yaml
persistentvolumeclaim/postgres-data created
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f secret.yaml
secret/postgres-secret configured
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f service.yaml
service/postgres configured
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pods,pvc
NAME                            READY   STATUS    RESTARTS   AGE
pod/postgres-69dcdb8955-gqvgn   1/1     Running   0          88s

NAME                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data   Bound    pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            standard       <unset>                 32s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> 

PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl wait --for=condition=available deployment/postgres --timeout=120s
deployment.apps/postgres condition met
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl exec -it deploy/postgres -- pg_isready -U postgres -d mydb
/var/run/postgresql:5432 - accepting connections

======================
replica:3

PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl apply -f deployment.yaml                                         
deployment.apps/postgres configured
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pods -l app=postgres
NAME                        READY   STATUS    RESTARTS     AGE
postgres-69dcdb8955-5vf4w   0/1     Running   1 (8s ago)   12s
postgres-69dcdb8955-gqvgn   1/1     Running   0            3m14s
postgres-69dcdb8955-t97gs   0/1     Running   0            12s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pods -l app=postgres
NAME                        READY   STATUS    RESTARTS      AGE
postgres-69dcdb8955-5vf4w   1/1     Running   1 (21s ago)   25s
postgres-69dcdb8955-gqvgn   1/1     Running   0             3m27s
postgres-69dcdb8955-t97gs   1/1     Running   0             25s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Bound    pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            standard       <unset>                 2m37s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> kubectl get pv 
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            Delete           Bound    default/postgres-data   standard       <unset>                          2m53s
PS D:\K8-Handson\Day3-4\k8s\db-as-deployment> 


==============================================

PS D:\K8-Handson\Day3-4\src> docker build -t devops-portal:latest .
[+] Building 10.3s (11/11) FINISHED                                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                                    0.2s
 => => transferring dockerfile: 762B                                                                                                    0.0s
 => [internal] load metadata for docker.io/library/python:3.13-slim                                                                     3.1s
 => [auth] library/python:pull token for registry-1.docker.io                                                                           0.0s
 => [internal] load .dockerignore                                                                                                       0.0s
 => => transferring context: 93B                                                                                                        0.0s
 => [1/5] FROM docker.io/library/python:3.13-slim@sha256:b04b5d7233d2ad9c379e22ea8927cd1378cd15c60d4ef876c065b25ea8fb3bf3               0.1s
 => => resolve docker.io/library/python:3.13-slim@sha256:b04b5d7233d2ad9c379e22ea8927cd1378cd15c60d4ef876c065b25ea8fb3bf3               0.0s
 => [internal] load build context                                                                                                       0.0s
 => => transferring context: 2.50kB                                                                                                     0.0s
 => CACHED [2/5] WORKDIR /app                                                                                                           0.0s
 => CACHED [3/5] COPY requirements.txt /app                                                                                             0.0s
 => CACHED [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                                     0.0s
 => CACHED [5/5] COPY . /app                                                                                                            0.0s
 => exporting to image                                                                                                                  6.1s
 => => exporting layers                                                                                                                 0.0s
 => => exporting manifest sha256:add0bf38f621381411f570fa88553365fbfca84fda4e100e1db988b574c7c29e                                       0.0s
 => => exporting config sha256:8e00566201754152f43598ae7b5002ce8b871964cce72b03a76fc3713e35155b                                         0.0s
 => => exporting attestation manifest sha256:779f81b0205c8301bbdcce8ca298240f546f11e5115c562299552e51058364d1                           0.4s
 => => exporting manifest list sha256:7e77d3620612ee9f878eaae48b5e2755cd5dde5aea332f903ec5a55349792755                                  0.0s
 => => naming to docker.io/library/devops-portal:latest                                                                                 0.0s
 => => unpacking to docker.io/library/devops-portal:latest                                                                              5.5s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/onbnexnf5fer13ss8gva98sz9
PS D:\K8-Handson\Day3-4\src> kind load docker-image devops-portal:latest --name day3-kind
Image: "devops-portal:latest" with ID "sha256:7e77d3620612ee9f878eaae48b5e2755cd5dde5aea332f903ec5a55349792755" not yet present on node "day3-kind-worker", loading...
Image: "devops-portal:latest" with ID "sha256:7e77d3620612ee9f878eaae48b5e2755cd5dde5aea332f903ec5a55349792755" not yet present on node "day3-kind-worker2", loading...
Image: "devops-portal:latest" with ID "sha256:7e77d3620612ee9f878eaae48b5e2755cd5dde5aea332f903ec5a55349792755" not yet present on node "day3-kind-worker3", loading...
Image: "devops-portal:latest" with ID "sha256:7e77d3620612ee9f878eaae48b5e2755cd5dde5aea332f903ec5a55349792755" not yet present on node "day3-kind-control-plane", loading...
PS D:\K8-Handson\Day3-4\src> 

Username
admin
Email
ad@gmail.com
Password
Kaju@123456


PS D:\K8-Handson\Day3-4\k8s\main> kubectl apply -f secret.yaml
secret/devops-portal-secret created
PS D:\K8-Handson\Day3-4\k8s\main> kubectl apply -f deployment-simple.yaml
deployment.apps/devops-portal-simple created
service/devops-portal-simple unchanged
PS D:\K8-Handson\Day3-4\k8s\main> kubectl get pods,svc -l app=devops-portal
NAME                                       READY   STATUS    RESTARTS   AGE
pod/devops-portal-simple-b65cd6759-9b7ft   1/1     Running   0          14s

NAME                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/devops-portal-simple   NodePort   10.96.43.138   <none>        8000:30001/TCP   41h
PS D:\K8-Handson\Day3-4\k8s\main> kubectl logs -l app=devops-portal,variant=simple --tail=20
[2026-05-31 09:05:04 +0000] [1] [INFO] Starting gunicorn 26.0.0
[2026-05-31 09:05:04 +0000] [1] [INFO] Listening at: http://0.0.0.0:8000 (1)
[2026-05-31 09:05:04 +0000] [1] [INFO] Using worker: sync
[2026-05-31 09:05:04 +0000] [11] [INFO] Booting worker with pid: 11
[2026-05-31 09:05:05 +0000] [1] [INFO] Control socket listening at /root/.gunicorn/gunicorn.ctl
PS D:\K8-Handson\Day3-4\k8s\main> kubectl port-forward svc/devops-portal-simple 8080:8000
Forwarding from 127.0.0.1:8080 -> 8000
Forwarding from [::1]:8080 -> 8000
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080

KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ curl -s http://localhost:8080/health
{"database":"connected","status":"healthy"}

$ kubectl get secrets
NAME                   TYPE     DATA   AGE
devops-portal-secret   Opaque   4      29m
postgres-secret        Opaque   3      41h



![alt text](image-1.png)



![alt text](image.png)
![alt text](image-2.png)
![alt text](image-3.png)


================

PS D:\K8-Handson\Day3-4\k8s> kubectl apply -f db-as-statefulset/
secret/postgres-secret configured
service/postgres configured
statefulset.apps/postgres created
service/postgres configured
service/postgres-writer unchanged
service/postgres-reader unchanged
statefulset.apps/postgres configured
PS D:\K8-Handson\Day3-4\k8s> kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     18s

NAME             READY   STATUS     RESTARTS   AGE
pod/postgres-0   0/1     Init:0/1   0          17s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data              Bound    pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            standard       <unset>                 38m
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-6fbce290-eb74-443d-8635-f805263ecacf   1Gi        RWO            standard       <unset>                 17s
PS D:\K8-Handson\Day3-4\k8s> kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     46s

NAME             READY   STATUS    RESTARTS   AGE
pod/postgres-0   0/1     Running   0          4s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data              Bound    pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            standard       <unset>                 39m
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-6fbce290-eb74-443d-8635-f805263ecacf   1Gi        RWO            standard       <unset>                 45s
PS D:\K8-Handson\Day3-4\k8s> kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   1/1     75s

NAME             READY   STATUS    RESTARTS   AGE
pod/postgres-0   1/1     Running   0          33s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data              Bound    pvc-c7d5f025-d430-415e-800c-e287fbd2b07d   1Gi        RWO            standard       <unset>                 39m
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-6fbce290-eb74-443d-8635-f805263ecacf   1Gi        RWO            standard       <unset>                 74s
PS D:\K8-Handson\Day3-4\k8s> kubectl wait --for=condition=ready pod/postgres-0 --timeout=120s
pod/postgres-0 condition met
PS D:\K8-Handson\Day3-4\k8s> kubectl get svc postgres -o wide
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE   SELECTOR
postgres   ClusterIP   None         <none>        5432/TCP   41h   app=postgres
PS D:\K8-Handson\Day3-4\k8s> kubectl exec -it postgres-0 -- pg_isready -U postgres -d mydb
/var/run/postgresql:5432 - accepting connections
PS D:\K8-Handson\Day3-4\k8s> 


KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s (main)
$ cd main

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f secret.yaml
secret/devops-portal-secret configured

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f deployment-simple.yaml
deployment.apps/devops-portal-simple created
service/devops-portal-simple unchanged

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl port-forward svc/devops-portal-simple 8080:8000
Forwarding from [::1]:8080 -> 8000
Handling connection for 8080

PS D:\K8-Handson\Day3-4\k8s\main> Invoke-WebRequest -Uri http://localhost:8080/health
   
Security Warning: Script Execution Risk
Invoke-WebRequest parses the content of the web page. Script code in the web page might be run when the page is parsed.
      RECOMMENDED ACTION:
      Use the -UseBasicParsing switch to avoid script code execution.

      Do you want to continue?
    
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): yes


StatusCode        : 200
StatusDescription : OK
Content           : {"database":"connected","status":"healthy"}
                    
RawContent        : HTTP/1.1 200 OK
                    Connection: close
                    Vary: Cookie
                    Content-Length: 44
                    Content-Type: application/json
                    Date: Sun, 31 May 2026 09:42:03 GMT
                    Server: gunicorn
                    
                    {"database":"connected","status":"healthy...
Forms             : {}
Headers           : {[Connection, close], [Vary, Cookie], [Content-Length, 44], [Content-Type, application/json]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 44



PS D:\K8-Handson\Day3-4\k8s\main> 