FROM jenkins/jenkins:lts

ENV CASC_JENKINS_CONFIG /usr/share/jenkins/casc.yaml

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN /usr/local/bin/install-plugins.sh git matrix-auth configuration-as-code

COPY casc.yaml /usr/share/jenkins/casc.yaml

ADD ./jenkins.tar.gz /var/jenkins_home/jobs

HEALTHCHECK --interval=4s --start-period=5s --retries=30 CMD [ "curl", "-f", "http://localhost/login" ]
