#!/bin/bash

VPC_NAME="alex-vpc"
FR_NAME="alex-ingres"
SUBNET_NAME="alex-subnet"
INSTANCE_NAME="alex-nginx"
INSTANCE_IMAGE_NAME="alex-nginx-image"
INSTANCE_ZONE="europe-west3-c"
INSTANCE_TYPE="e2-medium"
ALERT_VAR="0"

ALERT_VAR=$(gcloud compute networks list | grep -o $VPC_NAME)
if [ "$ALERT_VAR" = "$VPC_NAME" ]
 then
 echo network $ALERT_VAR already exist, please change name
# exit
fi

ALERT_VAR=$(gcloud compute firewall-rules list | grep -o $FR_NAME)
if [ "$ALERT_VAR" = "$FR_NAME" ]
 then
 echo firewall $FR_NAME already exist, please change name
# exit
fi

ALERT_VAR=$(gcloud compute networks subnets list | grep -o $SUBNET_NAME)
if [ "$ALERT_VAR" = "$SUBNET_NAME" ]
 then
 echo subnet $SUBNET_NAME already exist, please change name
# exit
fi

ALERT_VAR=$(gcloud compute instances list | grep -o $INSTANCE_NAME)
if [ "$ALERT_VAR" = "$INSTANCE_NAME" ]
 then
 echo compute instance $INSTANCE_NAME already exist, please change name
# exit
fi


#gcloud compute networks create $VPC_NAME --subnet-mode custom

#gcloud compute firewall-rules create $FR_NAME --network $VPC_NAME --allow tcp:22,tcp:80,tcp:443,tcp:8080,tcp:8081,tcp:8123,icmp

#gcloud compute networks subnets create $SUBNET_NAME --network $VPC_NAME --range 10.0.10.0/24

gcloud compute instances create alex-host1 \
--zone=$INSTANCE_ZONE  --machine-type=$INSTANCE_TYPE \
--image-project=centos-cloud --image-family=centos-7 \
--boot-disk-type=pd-standard --boot-disk-size=20GB \
--network $VPC_NAME \
--subnet $SUBNET_NAME \
--metadata-from-file=startup-script=/Users/alanovoy/gcp/sdk/setup.key.sh
#sleep 10
#gcloud beta compute machine-images create $INSTANCE_IMAGE_NAME  \
#    --source-instance $INSTANCE_NAME

gcloud compute instances create alex-host2 \
--zone=$INSTANCE_ZONE  --machine-type=$INSTANCE_TYPE \
--image-project=centos-cloud --image-family=centos-7 \
--boot-disk-type=pd-standard --boot-disk-size=20GB \
--network $VPC_NAME \
--subnet $SUBNET_NAME \
--metadata-from-file=startup-script=/Users/alanovoy/gcp/sdk/setup.key.sh

gcloud compute instances create alex-host3 \
--zone=$INSTANCE_ZONE  --machine-type=$INSTANCE_TYPE \
--image-project=centos-cloud --image-family=centos-7 \
--boot-disk-type=pd-standard --boot-disk-size=20GB \
--network $VPC_NAME \
--subnet $SUBNET_NAME \
--metadata-from-file=startup-script=/Users/alanovoy/gcp/sdk/setup.key.sh

sleep 120

echo "[jenkins]" > inventory
HOST=$(gcloud compute instances list | grep alex-host1 | awk '{print $5}') #>> inventory
echo $HOST "  env=jenkins" >> inventory
echo $HOST    jenkins > hosts

echo "[nexus]" >> inventory
HOST=$(gcloud compute instances list | grep alex-host2 | awk '{print $5}') # >> inventory
echo $HOST "  env=nexus" >> inventory
echo $HOST    nexus >> hosts
cat /dev/null > ~/.ssh/known_hosts

echo "[maven]" >> inventory
HOST=$(gcloud compute instances list | grep alex-host3 | awk '{print $5}') # >> inventory
echo $HOST "  env=maven" >> inventory
echo $HOST    maven >> hosts
cat /dev/null > ~/.ssh/known_hosts

HOST=$(gcloud compute instances list | grep alex-host1 | awk '{print $5}')
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine alanovoy@$HOST 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+I4T7EALZPAS/AvIC6mPON0CLz3DnbV441TAkqtPrOCKOyRzuvLXqvu+1zha704zbX1cjiCw1ibp8Hu9/28oWvxmlENCUxO++OA6T0xlSrmZa4Lfz3AZdVD0TzrygWiIYoIhQkqnKyR4WNoSM2+lrJoLgtn4BQqXPrcVZtqByEXOOzWMfMDGwd7EbWue9KRwWswa5fEMD+HnwQNn3WSPKuWV1tX6gvaBaVUy1NRoEpMAJhrLlOUCv2Om1k+ABAlOoqMFWJKSO1xTqSb3pa9iZ11EELTzbp2AJeqJm84GqOISAA0ESFB55A0LLbpCOqCjJAcpl9duinFPTzK5yZ3fQaVVCtBUnyvIX114Zr4hNrE45D51NG6q/amBvES/eLDN40rX58q5r5Ut9Xt7t4OvLdAf06EmN8TVVp0eS31NyOBDMMAPelmJYxiCQmmV9gAUTzdFWvGj2Oyef8f5lde/ryM6r3LAanrS/r3ejhYJktet3+Z765O1RGhuif5Q3rUs= alanovoy@C5776" >> /home/alanovoy/.ssh/authorized_keys'


HOST=$(gcloud compute instances list | grep alex-host2 | awk '{print $5}')
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine alanovoy@$HOST 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+I4T7EALZPAS/AvIC6mPON0CLz3DnbV441TAkqtPrOCKOyRzuvLXqvu+1zha704zbX1cjiCw1ibp8Hu9/28oWvxmlENCUxO++OA6T0xlSrmZa4Lfz3AZdVD0TzrygWiIYoIhQkqnKyR4WNoSM2+lrJoLgtn4BQqXPrcVZtqByEXOOzWMfMDGwd7EbWue9KRwWswa5fEMD+HnwQNn3WSPKuWV1tX6gvaBaVUy1NRoEpMAJhrLlOUCv2Om1k+ABAlOoqMFWJKSO1xTqSb3pa9iZ11EELTzbp2AJeqJm84GqOISAA0ESFB55A0LLbpCOqCjJAcpl9duinFPTzK5yZ3fQaVVCtBUnyvIX114Zr4hNrE45D51NG6q/amBvES/eLDN40rX58q5r5Ut9Xt7t4OvLdAf06EmN8TVVp0eS31NyOBDMMAPelmJYxiCQmmV9gAUTzdFWvGj2Oyef8f5lde/ryM6r3LAanrS/r3ejhYJktet3+Z765O1RGhuif5Q3rUs= alanovoy@C5776" >> /home/alanovoy/.ssh/authorized_keys'

HOST=$(gcloud compute instances list | grep alex-host3 | awk '{print $5}')
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine alanovoy@$HOST 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+I4T7EALZPAS/AvIC6mPON0CLz3DnbV441TAkqtPrOCKOyRzuvLXqvu+1zha704zbX1cjiCw1ibp8Hu9/28oWvxmlENCUxO++OA6T0xlSrmZa4Lfz3AZdVD0TzrygWiIYoIhQkqnKyR4WNoSM2+lrJoLgtn4BQqXPrcVZtqByEXOOzWMfMDGwd7EbWue9KRwWswa5fEMD+HnwQNn3WSPKuWV1tX6gvaBaVUy1NRoEpMAJhrLlOUCv2Om1k+ABAlOoqMFWJKSO1xTqSb3pa9iZ11EELTzbp2AJeqJm84GqOISAA0ESFB55A0LLbpCOqCjJAcpl9duinFPTzK5yZ3fQaVVCtBUnyvIX114Zr4hNrE45D51NG6q/amBvES/eLDN40rX58q5r5Ut9Xt7t4OvLdAf06EmN8TVVp0eS31NyOBDMMAPelmJYxiCQmmV9gAUTzdFWvGj2Oyef8f5lde/ryM6r3LAanrS/r3ejhYJktet3+Z765O1RGhuif5Q3rUs= alanovoy@C5776" >> /home/alanovoy/.ssh/authorized_keys'


ansible-playbook docker-rel1.yml
