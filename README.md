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

**Possible variables for the container:**"<br>
IMAGE="address-to-your-container-images"<br>
MOTD="Message of the day"<br>
WHITELIST="user1,user2,user3"<br>
OPS="user1"<br>

Now you can run the provided script
```bash
./create-mc-server-environment.sh
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

### Running locally
```bash
export PERSISTENT_STORAGE="mc-disk"<br>
export MSC_CLUSTER_NAME="mc-cluster"<br>
export ZONE="europe-west1-b"<br>
export MACHINE_TYPE="n1-standard-1"<br>

export IMAGE="<address-to-your-container-images>"<br>
export MOTD="Message of the day"<br>
export WHITELIST="user1,user2,user3"<br>
export OPS="user1"<br>

docker run -d -p 25565:25565 \
  --name mc \
  -e EULA=TRUE \
  -e TYPE=FORGE \
  -e WHITELIST="${WHITELIST}" \
  -e OPS="${WHITELIST}" \
  -e ALLOW_NETHER=true \
  -e ANNOUNCE_PLAYER_ACHIEVEMENTS=true \
  -e ENABLE_COMMAND_BLOCK=true \
  -e GENERATE_STRUCTURES=true \
  -e SPAWN_ANIMALS=true \
  -e SPAWN_MONSTERS=true \
  -e SPAWN_NPCS=true \
  -e MOTD="${MOTD}" \
  itzg/minecraft-server
```


## Disclaimer
* Scripts and instructions are provided AS IS.
* ÚSe these instructions with your own risk.
* There is no guarantee any of it works for your environment.
* There is no Support provided