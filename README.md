# minecraft-server
Minecraft server on Google Container Engine


### Create disk for persistent data

Possible variables:<br>
PERSISTENT_STORAGE="mc-disk"<br>
MSC_CLUSTER_NAME="mc-cluster"<br>
ZONE="europe-west1-b"<br>
MACHINE_TYPE="n1-standard-1"<br>

```bash
gcloud compute disks create --size 200GB ${PERSISTENT_STORAGE}

Created [https://www.googleapis.com/compute/v1/projects/minecraft-server-185418/zones/${ZONE}/disks/${PERSISTENT_STORAGE}].
NAME           ZONE            SIZE_GB  TYPE         STATUS
${PERSISTENT_STORAGE}  ${ZONE}  200      pd-standard  READY
```

New disks are unformatted. You must format and mount a disk before it<br>
can be used. You can find instructions on how to do this at:

[https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting](https://cloud.google.com/compute/docs/disks/add-persistent-disk#formatting)

### Create container cluster
```bash
gcloud container clusters create ${MSC_CLUSTER_NAME} \
  --zone ${ZONE} \
  --machine-type ${MACHINE_TYPE} \
  --num-nodes 1 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 2
Creating cluster ${MSC_CLUSTER_NAME}...done.
Created [https://container.googleapis.com/v1/projects/minecraft-server-185418/zones/${ZONE}/clusters/${MSC_CLUSTER_NAME}].
kubeconfig entry generated for ${MSC_CLUSTER_NAME}.
NAME            ZONE            MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
${MSC_CLUSTER_NAME}  ${ZONE}  1.7.8-gke.0     11.222.111.33  ${MACHINE_TYPE}  1.7.8-gke.0   1          RUNNING
```


### Reference
[https://cloud.google.com/container-engine/docs/tutorials/persistent-disk](https://cloud.google.com/container-engine/docs/tutorials/persistent-disk)

```bash
# Riff Raff
gcloud container clusters create example-cluster
kubectl run hello-web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
kubectl expose deployment hello-web --type="LoadBalancer"
kubectl get service hello-web
kubectl delete service hello-web
gcloud container clusters delete example-cluster
 ```