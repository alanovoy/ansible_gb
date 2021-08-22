#!/bin/bash

PASS=$(docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword)
docker cp ./config.xml jenkins :/var/jenkins_home/
curl -u admin:$PASS localhost/restart

curl -X POST -H content-type:application/xml -d @credential.xml 'http://localhost/credentials/store/system/domain/_/credential/apicredentials/config.xml'
