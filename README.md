# minecraft-server
Minecraft server on Google Container Engine

### Comments

While containers can be launched with persistent disk, how does noe access that disk?
How does one access the container gcloud exec? kubectl exec?

$ gcloud config configurations activate minecraft

```shell
# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: mcs-pv-claim
# spec:
#   accessModes:
#     - ReadWriteOnce <----????
#   resources:
#     requests:
#       storage: 50G
```


### Tools needed
* [Gcloud SDK](https://cloud.google.com/sdk/downloads)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Create disk for persistent data

**Possible variables:** <br>
PERSISTENT_STORAGE="mc-disk"<br>
MSC_CLUSTER_NAME="mc-cluster"<br>
ZONE="europe-west1-b"<br>
MACHINE_TYPE="n1-standard-1"<br>

### Create container cluster and service
```bash
./create-mc-server-environment.sh
```

### Expose the IP address
```bash
kubectl expose deployment mc-server --type="LoadBalancer"

# Check the values
kubectl get services mc-server
```

### Misc

If there is a need for (non-beta) persistent disk

[https://cloud.google.com/container-engine/docs/tutorials/persistent-disk](https://cloud.google.com/container-engine/docs/tutorials/persistent-disk)

```bash
gcloud compute disks create --size 200GB ${PERSISTENT_STORAGE}

Created [https://www.googleapis.com/compute/v1/projects/minecraft-server-185418/zones/${ZONE}/disks/${PERSISTENT_STORAGE}].
NAME           ZONE            SIZE_GB  TYPE         STATUS
${PERSISTENT_STORAGE}  ${ZONE}  200      pd-standard  READY
```

New disks are unformatted. You must format and mount a disk before it<br>
can be used. You can find instructions on how to do this at:

[https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting)


```bash
# Riff Raff
gcloud container clusters create example-cluster
kubectl run hello-web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
kubectl expose deployment hello-web --type="LoadBalancer"
kubectl get service hello-web
kubectl describe pods hello-web
kubectl delete service hello-web
gcloud container clusters delete example-cluster
 ```

#### Commands
```bash
kubectl cluster-info
kubectl get nodes

```