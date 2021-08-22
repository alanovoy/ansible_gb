#!/bin/bash

FIRST_PASS=$(docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword)
NEW_PASS="Cf,frf500"

curl -ifu admin:"${FIRST_PASS}" \
  -XPUT -H 'Content-Type: text/plain' \
  --data "${NEW_PASS}" \	
  localhost:8081/service/rest/v1/security/users/admin/change-password
