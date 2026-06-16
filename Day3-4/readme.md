
kind create cluster --name day2-kind --config kind-config.yaml


## Output

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4 (main)
$ kind create cluster --name day3-kind --config kind-config.yaml
Creating cluster "day3-kind" ...
 • Ensuring node image (kindest/node:v1.33.1) 🖼  ...
 ✓ Ensuring node image (kindest/node:v1.33.1) 🖼
 • Preparing nodes 📦 📦 📦 📦   ...
 ✓ Preparing nodes 📦 📦 📦 📦 
 • Writing configuration 📜  ...
 ✓ Writing configuration 📜
 • Starting control-plane 🕹️  ...
 ✓ Starting control-plane 🕹️
 • Installing CNI 🔌  ...
 ✓ Installing CNI 🔌
 • Installing StorageClass 💾  ...
 ✓ Installing StorageClass 💾
 • Joining worker nodes 🚜  ...
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-day3-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-day3-kind

Thanks for using kind! 😊

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4 (main)
$ kubectl cluster-info --context kind-day3-kind
Kubernetes control plane is running at https://127.0.0.1:49672
CoreDNS is running at https://127.0.0.1:49672/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4 (main)
$ kubectl get nodes
NAME                      STATUS   ROLES           AGE   VERSION
day3-kind-control-plane   Ready    control-plane   44s   v1.33.1
day3-kind-worker          Ready    <none>          27s   v1.33.1
day3-kind-worker2         Ready    <none>          28s   v1.33.1
day3-kind-worker3         Ready    <none>          27s   v1.33.1

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4 (main)
$ kubectl get storageclass
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  87s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4 (main)
$ kubectl get sc -o yaml | grep -A2 volumeBindingMode
        {"apiVersion":"storage.k8s.io/v1","kind":"StorageClass","metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"},"name":"standard"},"provisioner":"rancher.io/local-path","reclaimPolicy":"Delete","volumeBindingMode":"WaitForFirstConsumer"}
      storageclass.kubernetes.io/is-default-class: "true"
    creationTimestamp: "2026-05-29T13:43:41Z"
--
  volumeBindingMode: WaitForFirstConsumer
kind: List
metadata:




KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s (main)
$ cd db-as-deployment

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f pvc.yaml
persistentvolumeclaim/postgres-data created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pvc
NAME            STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Pending                                      standard       <unset>                 10s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pv
No resources found


KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl delete deployment postgres --ignore-not-found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl delete pvc postgres-data --ignore-not-found
persistentvolumeclaim "postgres-data" deleted

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f deployment.yaml
deployment.apps/postgres created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-bwwk6   0/1     Pending   0          27s
postgres-69dcdb8955-h2tvj   0/1     Pending   0          27s
postgres-69dcdb8955-tv7p5   0/1     Pending   0          27s




KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pod -l app=postgres
Name:             postgres-69dcdb8955-bwwk6
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
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2cb7x (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-2cb7x:
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
  Warning  FailedScheduling  36s   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.


Name:             postgres-69dcdb8955-h2tvj
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
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bgshr (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-bgshr:
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
  Warning  FailedScheduling  36s   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.


Name:             postgres-69dcdb8955-tv7p5
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
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-l85br (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-l85br:
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
  Warning  FailedScheduling  36s   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f pvc.yaml
persistentvolumeclaim/postgres-data created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f secret.yaml
secret/postgres-secret created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f service.yaml
service/postgres created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods
NAME                        READY   STATUS              RESTARTS   AGE
postgres-69dcdb8955-bwwk6   0/1     ContainerCreating   0          3m6s
postgres-69dcdb8955-h2tvj   0/1     ContainerCreating   0          3m6s
postgres-69dcdb8955-tv7p5   0/1     ContainerCreating   0          3m6s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Bound    pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            standard       <unset>                 42s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            Delete           Bound    default/postgres-data   standard       <unset>                          40s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods
NAME                        READY   STATUS              RESTARTS   AGE
postgres-69dcdb8955-bwwk6   0/1     ContainerCreating   0          3m29s
postgres-69dcdb8955-h2tvj   0/1     ContainerCreating   0          3m29s
postgres-69dcdb8955-tv7p5   0/1     ContainerCreating   0          3m29s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-bwwk6   1/1     Running   0          4m23s
postgres-69dcdb8955-h2tvj   1/1     Running   0          4m23s
postgres-69dcdb8955-tv7p5   1/1     Running   0          4m23s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl wait --for=condition=available deployment/postgres --timeout=120s
deployment.apps/postgres condition met

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl exec -it deploy/postgres -- pg_isready -U postgres -d mydb
/var/run/postgresql:5432 - accepting connections

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl apply -f deployment.yaml
deployment.apps/postgres unchanged

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods -l app=postgres
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-bwwk6   1/1     Running   0          5m44s
postgres-69dcdb8955-h2tvj   1/1     Running   0          5m44s
postgres-69dcdb8955-tv7p5   1/1     Running   0          5m44s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Bound    pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            standard       <unset>                 3m20s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pods -l app=postgres | grep -A10 "Events:"
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  16m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  14m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         13m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-bwwk6 to day3-kind-worker3
  Normal   Pulling           13m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            12m   kubelet            Successfully pulled image "postgres:15" in 2.208s (1m20.381s including waiting). Image size: 158106937 bytes.
  Normal   Created           12m   kubelet            Created container: postgres
  Normal   Started           12m   kubelet            Started container postgres

--
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  16m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Normal   Scheduled         13m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-h2tvj to day3-kind-worker3
  Normal   Pulling           13m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            12m   kubelet            Successfully pulled image "postgres:15" in 1m18.41s (1m18.41s including waiting). Image size: 158106937 bytes.
  Normal   Created           12m   kubelet            Created container: postgres
  Normal   Started           12m   kubelet            Started container postgres


--
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  16m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  14m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         13m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-tv7p5 to day3-kind-worker3
  Normal   Pulling           13m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            12m   kubelet            Successfully pulled image "postgres:15" in 1.329s (1m21.672s including waiting). Image size: 158106937 bytes.
  Normal   Created           12m   kubelet            Created container: postgres
  Normal   Started           12m   kubelet            Started container postgres

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pvc postgres-data | grep -i "access modes"
Access Modes:  RWO

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pod -l app=postgres | grep -i "multi-attach\|cannot\|failed"
  Warning  FailedScheduling  18m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  15m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Warning  FailedScheduling  18m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  18m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  15m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ $ kubectl get pods -l app=postgres
bash: $: command not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ $ kubectl get pods -l app=postgre
bash: $: command not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ $ kubectl get pods 
bash: $: command not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ $ kubectl get pod
bash: $: command not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pods -l app=postgres | grep -A5 "FailedScheduling"
  Warning  FailedScheduling  21m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  19m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         18m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-bwwk6 to day3-kind-worker3
  Normal   Pulling           18m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            17m   kubelet            Successfully pulled image "postgres:15" in 2.208s (1m20.381s including waiting). Image size: 158106937 bytes.
  Normal   Created           17m   kubelet            Created container: postgres
  Normal   Started           17m   kubelet            Started container postgres
--
  Warning  FailedScheduling  21m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Normal   Scheduled         18m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-h2tvj to day3-kind-worker3
  Normal   Pulling           18m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            17m   kubelet            Successfully pulled image "postgres:15" in 1m18.41s (1m18.41s including waiting). Image size: 158106937 bytes.
  Normal   Created           17m   kubelet            Created container: postgres
  Normal   Started           17m   kubelet            Started container postgres
--
  Warning  FailedScheduling  21m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  19m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         18m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-tv7p5 to day3-kind-worker3
  Normal   Pulling           18m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            17m   kubelet            Successfully pulled image "postgres:15" in 1.329s (1m21.672s including waiting). Image size: 158106937 bytes.
  Normal   Created           17m   kubelet            Created container: postgres
  Normal   Started           17m   kubelet            Started container postgres

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ $ kubectl get pod
bash: $: command not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$  kubectl get pod
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-bwwk6   1/1     Running   0          22m
postgres-69dcdb8955-h2tvj   1/1     Running   0          22m
postgres-69dcdb8955-tv7p5   1/1     Running   0          22m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pods -l app=postgres
NAME                        READY   STATUS    RESTARTS   AGE
postgres-69dcdb8955-bwwk6   1/1     Running   0          38m
postgres-69dcdb8955-h2tvj   1/1     Running   0          38m
postgres-69dcdb8955-tv7p5   1/1     Running   0          38m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-data   Bound    pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            standard       <unset>                 36m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            Delete           Bound    default/postgres-data   standard       <unset>                          36m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ kubectl describe pod -l app=postgres
Name:             postgres-69dcdb8955-bwwk6
Namespace:        default
Priority:         0
Service Account:  default
Node:             day3-kind-worker3/172.18.0.4
Start Time:       Fri, 29 May 2026 19:21:50 +0530
Labels:           app=postgres
                  pod-template-hash=69dcdb8955
Annotations:      <none>
Status:           Running
IP:               10.244.2.5
IPs:
  IP:           10.244.2.5
Controlled By:  ReplicaSet/postgres-69dcdb8955
Containers:
  postgres:
    Container ID:   containerd://4cdd38bb1c5f6a389ee0d6b2e2d818e54180d41a36f1b72cdf6cbad479e1df9f
    Image:          postgres:15
    Image ID:       docker.io/library/postgres@sha256:1b92e7a80c021647bf70f5d3eb66066a998e4f5cf43c07bb9dc9f729782cf88e
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 29 May 2026 19:23:12 +0530
    Ready:          True
    Restart Count:  0
    Liveness:       exec [pg_isready -U postgres -d mydb] delay=30s timeout=1s period=20s #success=1 #failure=3
    Readiness:      exec [pg_isready -U postgres -d mydb] delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:
      random-env-variable:  random-value
      POSTGRES_USER:        <set to the key 'POSTGRES_USER' in secret 'postgres-secret'>      Optional: false
      POSTGRES_PASSWORD:    <set to the key 'POSTGRES_PASSWORD' in secret 'postgres-secret'>  Optional: false
      POSTGRES_DB:          <set to the key 'POSTGRES_DB' in secret 'postgres-secret'>        Optional: false
      PGDATA:               /var/lib/postgresql/data/pgdata
    Mounts:
      /var/lib/postgresql/data from postgres-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2cb7x (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-2cb7x:
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
  Warning  FailedScheduling  41m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  39m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         39m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-bwwk6 to day3-kind-worker3
  Normal   Pulling           39m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            37m   kubelet            Successfully pulled image "postgres:15" in 2.208s (1m20.381s including waiting). Image size: 158106937 bytes.
  Normal   Created           37m   kubelet            Created container: postgres
  Normal   Started           37m   kubelet            Started container postgres


Name:             postgres-69dcdb8955-h2tvj
Namespace:        default
Priority:         0
Service Account:  default
Node:             day3-kind-worker3/172.18.0.4
Start Time:       Fri, 29 May 2026 19:21:50 +0530
Labels:           app=postgres
                  pod-template-hash=69dcdb8955
Annotations:      <none>
Status:           Running
IP:               10.244.2.3
IPs:
  IP:           10.244.2.3
Controlled By:  ReplicaSet/postgres-69dcdb8955
Containers:
  postgres:
    Container ID:   containerd://e1b5fd590fe5642e7b0f820658da0348c48e6a2d30866af35203c73228a54a66
    Image:          postgres:15
    Image ID:       docker.io/library/postgres@sha256:1b92e7a80c021647bf70f5d3eb66066a998e4f5cf43c07bb9dc9f729782cf88e
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 29 May 2026 19:23:10 +0530
    Ready:          True
    Restart Count:  0
    Liveness:       exec [pg_isready -U postgres -d mydb] delay=30s timeout=1s period=20s #success=1 #failure=3
    Readiness:      exec [pg_isready -U postgres -d mydb] delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:
      random-env-variable:  random-value
      POSTGRES_USER:        <set to the key 'POSTGRES_USER' in secret 'postgres-secret'>      Optional: false
      POSTGRES_PASSWORD:    <set to the key 'POSTGRES_PASSWORD' in secret 'postgres-secret'>  Optional: false
      POSTGRES_DB:          <set to the key 'POSTGRES_DB' in secret 'postgres-secret'>        Optional: false
      PGDATA:               /var/lib/postgresql/data/pgdata
    Mounts:
      /var/lib/postgresql/data from postgres-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bgshr (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-bgshr:
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
  Warning  FailedScheduling  41m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Normal   Scheduled         39m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-h2tvj to day3-kind-worker3
  Normal   Pulling           39m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            37m   kubelet            Successfully pulled image "postgres:15" in 1m18.41s (1m18.41s including waiting). Image size: 158106937 bytes.
  Normal   Created           37m   kubelet            Created container: postgres
  Normal   Started           37m   kubelet            Started container postgres


Name:             postgres-69dcdb8955-tv7p5
Namespace:        default
Priority:         0
Service Account:  default
Node:             day3-kind-worker3/172.18.0.4
Start Time:       Fri, 29 May 2026 19:21:50 +0530
Labels:           app=postgres
                  pod-template-hash=69dcdb8955
Annotations:      <none>
Status:           Running
IP:               10.244.2.4
IPs:
  IP:           10.244.2.4
Controlled By:  ReplicaSet/postgres-69dcdb8955
Containers:
  postgres:
    Container ID:   containerd://39bafbc4e1fffa7afce0696d3bf204c7475e70b2b2a2778300cc6fe109df7dde
    Image:          postgres:15
    Image ID:       docker.io/library/postgres@sha256:1b92e7a80c021647bf70f5d3eb66066a998e4f5cf43c07bb9dc9f729782cf88e
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 29 May 2026 19:23:13 +0530
    Ready:          True
    Restart Count:  0
    Liveness:       exec [pg_isready -U postgres -d mydb] delay=30s timeout=1s period=20s #success=1 #failure=3
    Readiness:      exec [pg_isready -U postgres -d mydb] delay=5s timeout=1s period=10s #success=1 #failure=3
    Environment:
      random-env-variable:  random-value
      POSTGRES_USER:        <set to the key 'POSTGRES_USER' in secret 'postgres-secret'>      Optional: false
      POSTGRES_PASSWORD:    <set to the key 'POSTGRES_PASSWORD' in secret 'postgres-secret'>  Optional: false
      POSTGRES_DB:          <set to the key 'POSTGRES_DB' in secret 'postgres-secret'>        Optional: false
      PGDATA:               /var/lib/postgresql/data/pgdata
    Mounts:
      /var/lib/postgresql/data from postgres-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-l85br (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  postgres-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  postgres-data
    ReadOnly:   false
  kube-api-access-l85br:
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
  Warning  FailedScheduling  41m   default-scheduler  0/4 nodes are available: persistentvolumeclaim "postgres-data" not found. preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
  Warning  FailedScheduling  39m   default-scheduler  running PreBind plugin "VolumeBinding": Operation cannot be fulfilled on persistentvolumeclaims "postgres-data": the object has been modified; please apply your changes to the latest version and try again
  Normal   Scheduled         39m   default-scheduler  Successfully assigned default/postgres-69dcdb8955-tv7p5 to day3-kind-worker3
  Normal   Pulling           39m   kubelet            Pulling image "postgres:15"
  Normal   Pulled            37m   kubelet            Successfully pulled image "postgres:15" in 1.329s (1m21.672s including waiting). Image size: 158106937 bytes.
  Normal   Created           37m   kubelet            Created container: postgres
  Normal   Started           37m   kubelet            Started container postgres

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-deployment (main)
$ cd day3-4/src
bash: cd: day3-4/src: No such file or directory

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ docker tag devops-portal:latest kajal909/devops-portal:latest

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ docker push kajal909/devops-portal:latest
The push refers to repository [docker.io/kajal909/devops-portal]
a4152e6203f4: Pushed 
5808a7611d40: Pushed 

$ kubectl apply -f secret.yaml
secret/devops-portal-secret created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f deployment-simple.yaml
deployment.apps/devops-portal-simple created
service/devops-portal-simple created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl get pods,svc -l app=devops-portal

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f deployment-simple.yaml
deployment.apps/devops-portal-simple configured
service/devops-portal-simple unchanged

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl get pods,svc -l app=devops-portal
NAME                                        READY   STATUS        RESTARTS   AGE
pod/devops-portal-simple-5555d7654b-49rtd   0/1     Terminating   0          13m
pod/devops-portal-simple-b65cd6759-r47hl    1/1     Running       0          7s

NAME                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/devops-portal-simple   NodePort   10.96.133.81   <none>        8000:30001/TCP   13m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl get pods,svc -l app=devops-portal
NAME                                       READY   STATUS    RESTARTS   AGE
pod/devops-portal-simple-b65cd6759-r47hl   1/1     Running   0          13s

NAME                           TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/devops-portal-simple   NodePort   10.96.133.81   <none>        8000:30001/TCP   13m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl logs -l app=devops-portal,variant=simple --tail=20
[2026-05-29 14:54:42 +0000] [1] [INFO] Starting gunicorn 26.0.0
[2026-05-29 14:54:42 +0000] [1] [INFO] Listening at: http://0.0.0.0:8000 (1)
[2026-05-29 14:54:42 +0000] [1] [INFO] Using worker: sync
[2026-05-29 14:54:42 +0000] [11] [INFO] Booting worker with pid: 11
[2026-05-29 14:54:42 +0000] [1] [INFO] Control socket listening at /root/.gunicorn/gunicorn.ctl


KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl port-forward svc/devops-portal-simple 8080:8000
Forwarding from 127.0.0.1:8080 -> 8000
Forwarding from [::1]:8080 -> 8000
Handling connection for 8080

KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ curl -s http://localhost:8080/health
{"database":"connected","status":"healthy"}






==================

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s (main)
$ cd db-as-statefulset

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                                       READY   STATUS    RESTARTS      AGE
pod/devops-portal-simple-b65cd6759-r47hl   1/1     Running   2 (56m ago)   62m
pod/postgres-69dcdb8955-bwwk6              1/1     Running   0             127m
pod/postgres-69dcdb8955-h2tvj              1/1     Running   0             127m
pod/postgres-69dcdb8955-tv7p5              1/1     Running   0             127m

NAME                                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data   Bound    pvc-31c05993-cbc9-47d7-817a-b57d7ebcf8b0   1Gi        RWO            standard       <unset>                 125m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl wait --for=condition=ready pod/postgres-0 --timeout=120s
Error from server (NotFound): pods "postgres-0" not found

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl delete -f /d/K8-Handson/Day3-4/k8s/db-as-deployment/ --ignore-not-found
deployment.apps "postgres" deleted
persistentvolumeclaim "postgres-data" deleted
secret "postgres-secret" deleted
service "postgres" deleted

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl delete -f /d/K8-Handson/Day3-4/k8s/main/deployment-simple.yaml --ignore-not-found
deployment.apps "devops-portal-simple" deleted
service "devops-portal-simple" deleted

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   134m

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl apply -f /d/K8-Handson/Day3-4/k8s/db-as-statefulset/
secret/postgres-secret created
service/postgres created
statefulset.apps/postgres created
service/postgres configured
service/postgres-writer created
service/postgres-reader created
statefulset.apps/postgres configured

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     13s

NAME             READY   STATUS            RESTARTS   AGE
pod/postgres-0   0/1     PodInitializing   0          13s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 13s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     19s

NAME             READY   STATUS            RESTARTS   AGE
pod/postgres-0   0/1     PodInitializing   0          19s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 19s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     31s

NAME             READY   STATUS            RESTARTS   AGE
pod/postgres-0   0/1     PodInitializing   0          31s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 31s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   0/1     61s

NAME             READY   STATUS            RESTARTS   AGE
pod/postgres-0   0/1     PodInitializing   0          61s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 61s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get statefulset,pods,pvc
NAME                        READY   AGE
statefulset.apps/postgres   1/1     115s

NAME             READY   STATUS    RESTARTS   AGE
pod/postgres-0   1/1     Running   0          19s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 115s

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl wait --for=condition=ready pod/postgres-0 --timeout=120s
pod/postgres-0 condition met

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl get svc postgres -o wide
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE     SELECTOR
postgres   ClusterIP   None         <none>        5432/TCP   2m44s   app=postgres

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ kubectl exec -it postgres-0 -- pg_isready -U postgres -d mydb
/var/run/postgresql:5432 - accepting connections

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/db-as-statefulset (main)
$ cd ..

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s (main)
$ cd main

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f day3-4/k8s/main/secret.yaml
error: the path "day3-4/k8s/main/secret.yaml" does not exist

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f secret.yaml
secret/devops-portal-secret configured

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl apply -f deployment-simple.yaml
deployment.apps/devops-portal-simple created
service/devops-portal-simple created

KAJAL@KAJAL MINGW64 /d/K8-Handson/Day3-4/k8s/main (main)
$ kubectl port-forward svc/devops-portal-simple 8080:8000
Forwarding from [::1]:8080 -> 8000
Handling connection for 8080
Handling connection for 8080


KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ curl -s http://localhost:8080/health
{"database":"connected","status":"healthy"}

KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ kubectl get nodes
NAME                      STATUS   ROLES           AGE    VERSION
day3-kind-control-plane   Ready    control-plane   139m   v1.33.1
day3-kind-worker          Ready    <none>          139m   v1.33.1
day3-kind-worker2         Ready    <none>          139m   v1.33.1
day3-kind-worker3         Ready    <none>          139m   v1.33.1

KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ kubectl get pods,pvc,svc
NAME                                       READY   STATUS    RESTARTS   AGE
pod/devops-portal-simple-b65cd6759-vj5nd   1/1     Running   0          49s
pod/postgres-0                             1/1     Running   0          3m5s

NAME                                             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
persistentvolumeclaim/postgres-data-postgres-0   Bound    pvc-7624af70-6a15-490c-a443-2a317c194a85   1Gi        RWO            standard       <unset>                 4m41s

NAME                           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/devops-portal-simple   NodePort    10.96.43.138   <none>        8000:30001/TCP   49s
service/kubernetes             ClusterIP   10.96.0.1      <none>        443/TCP          139m
service/postgres               ClusterIP   None           <none>        5432/TCP         4m41s
service/postgres-reader        ClusterIP   10.96.107.29   <none>        5432/TCP         4m41s
service/postgres-writer        ClusterIP   10.96.49.43    <none>        5432/TCP         4m41s

KAJAL@KAJAL MINGW64 /d/K8-Handson (main)
$ 