# minecraft-server
Minecraft server on Google Container Engine


### Tools needed
* Understanding of Linux command-line
* Google account
* [Gcloud SDK](https://cloud.google.com/sdk/downloads)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Container engine](https://cloud.google.com/container-engine/docs/quickstart)
* Local docker installation [Install Docker](https://docs.docker.com/engine/installation/)
* Addition to docker, you'll need `jq` and `gettext` installed for your Linux distribution
* Minecraft server container. I've used [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server/)
* **Study and learn from the links provided**


### Setting up

#### Create container cluster and service
You either want to set up your Google Container Engine to either [mirror the official Docker hub](https://cloud.google.com/container-registry/docs/using-dockerhub-mirroring), or you can pull the image first to your local system, and then push it to the GCE registry.

**Pulling the image, and then pushing into the GCE registry**
```bash
# Pull the image
docker pull itzg/minecraft-server
```

Set tags according to your [Project ID](https://support.google.com/cloud/answer/6158840?hl=en) and [Registry location](https://cloud.google.com/container-registry/docs/quickstart)

Example:
```bash
docker images
REPOSITORY                                                TAG                 IMAGE ID            CREATED             SIZE
itzg/minecraft-server                                     latest              0d7b50698515        11 days ago         295MB
# Set tag for your registry
docker tag itzg/minecraft-server eu.gcr.io/minecraft-server-35678/minecraft-server
# Push to registry
gcloud docker -- push eu.gcr.io/minecraft-server-35678/minecraft-server
```

**Please make sure your IMAGE variable has the value of the TAG you set and pushed above**

Edit the Variables for cluster and container to your own

**Possible variables:** <br>
PERSISTENT_STORAGE="mc-disk"<br>
MSC_CLUSTER_NAME="mc-cluster"<br>
ZONE="europe-west1-b"<br>
MACHINE_TYPE="n1-standard-1"<br>

**Possible variables for the container:** <br>
IMAGE="address-to-your-container-images"<br>
MOTD="Message of the day"<br>
WHITELIST="user1,user2,user3"<br>
OPS="user1"<br>

Now you can run the provided script
```bash
./create-mc-server-environment.sh
```

### Remove deployment and the cluster
Sometimes things go south and errors happen.<br>
These commands allow you to smoothly start over.

**Delete the deployment**
```bash
kubectl delete -f mcs-deployment.yaml
```

**Delete the entire cluster**
```bash
gcloud container clusters delete ${MSC_CLUSTER_NAME} --zone ${ZONE} --quiet
```

**If you are not planning of running the MC server for a while, delete IP address as well** <br>
```bash
gcloud compute addresses delete minecraft-ip --region ${REGION} --quiet
```

### Connecting to the running container
If and when you need to connect to your running container for whatever reason. This is how you can do it.

```bash
# Get container name
kubectl get pods -o json | jq -r .items[].metadata.name
# Connect to it via normal docker-like method
kubectl exec -it CONTAINER_NAME bash
# or providing both commands in one-liner
kubectl exec -it $(kubectl get pods -o json | jq -r .items[].metadata.name) bash
# The latter command will not work if you have more than one container
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


### Commands
[Cheat sheet](https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/)

```bash
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -o wide
# Container name
kubectl get pods -o json | jq -r .items[].metadata.name
```

```bash
# List disk allocation in your container
kubectl exec -it $(kubectl get pods -o json | jq -r .items[].metadata.name) -- bash -c "df -h"
# File listing in your container
kubectl exec -it $(kubectl get pods -o json | jq -r .items[].metadata.name) -- bash -c "ls -la"
```

### Running locally

We use [docker-compose](https://docs.docker.com/compose/overview/) to run the server locally. Install by running `pip install docker-compose`.

First you want to rename the `env_template` to `.env`, and edit the variables within accordingly.
```bash
# To start the service
docker-compose up -d

# To review the logs
docker-compose logs -f

# To shut down
docker-compose down
```

Clean up the volumes if you don't want to save the existing server data.
```bash
docker volume prune
```


## Disclaimer
* Scripts and instructions are provided AS IS.
* ÚSe these instructions with your own risk.
* There is no guarantee any of it works for your environment.
* There is no Support provided