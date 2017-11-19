#!/bin/bash
set -e

WHITE="\e[1;37m"
GREEN="\e[1;32m"
RED="\e[1;31m"
NC="\e[0m"

DONE="${WHITE}[${GREEN}DONE${WHITE}]${NC}"

# Variables:
REGION="europe-west1"
ZONE="europe-west1-b"
NODES="2"
MSC_CLUSTER_NAME="mc-cluster-name"
KUBERNETES_VERSION="1.8.2-gke.0"
MACHINE_TYPE="n1-standard-1"
PERSISTENT_STORAGE="mc-disk-name"

# Container variables to .yaml file:
export IMAGE="<address-to-your-container-images>"
export MOTD="Message of the day"
export WHITELIST="user1,user2,user3"
export OPS="user1"


# Set up cluster
gcloud container clusters create ${MSC_CLUSTER_NAME} \
  --zone ${ZONE} \
  --cluster-version ${KUBERNETES_VERSION} \
  --machine-type ${MACHINE_TYPE} \
  --num-nodes ${NODES} \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes ${NODES} \
  --preemptible  # This flag most likely has no effect in this scenario

echo
echo -en ${DONE}
echo

# Get persistent IP address
set +e
CHECK_IP=$(gcloud compute addresses describe minecraft-ip --region ${REGION} --format json)
if [[ ! $? -eq 0 ]]; then
  gcloud compute addresses create minecraft-ip --region ${REGION}
  CHECK_IP=$(gcloud compute addresses describe minecraft-ip --region ${REGION} --format json)
fi
export MC_IP_ADDRESS=$(echo ${CHECK_IP} | jq -r .address)
set -e

echo
echo "Running container deployment to the cluster"
echo
echo "If something goes wrong, delete created resources by running:"
echo "kubectl delete -f mcs-deployment.yaml"
echo
echo "Or you can delete the entire cluster:"
echo "gcloud container clusters delete mc-cluster --zone ${ZONE} --quiet"
echo
echo "If you are not planning of running the MC server for a while, delete IP address as well:"
echo "gcloud compute addresses delete minecraft-ip --region ${REGION} --quiet"
echo

# Replace variables in the .yaml file and deploy
envsubst < mcs-deployment.yaml | kubectl create -f -
sleep 10
echo -en ${DONE}
echo

kubectl get pods -o=wide
echo
kubectl get svc -o=wide

echo
echo "In order to get the container name only. Issue the command:"
echo "kubectl get pods -o json | jq -r .items[].metadata.name"
echo
echo "Then you can connect to the container via:"
echo "kubectl exec -it SERVER_NAME bash"
echo
