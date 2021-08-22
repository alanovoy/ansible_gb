#!/bin/bash

FIRST_PASS=$(docker exec -it nexus cat /nexus-data/admin.password)
NEW_PASS="Cf,frf500"

curl -ifu admin:"${FIRST_PASS}" \
  -XPUT -H 'Content-Type: text/plain' \
  --data "${NEW_PASS}" \
  localhost:8081/service/rest/v1/security/users/admin/change-password
