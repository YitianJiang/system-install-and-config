############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
set -u
exec 2>$SYSTEM_INSTALL_AND_CONFIG/log
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/docker-install.sh

# #referencce: https://www.jenkins.io/doc/book/installing/docker/
# docker network create jenkins
# #change --rm to --restart=always
# docker run --name jenkins-docker \
#   --restart=always --detach \
#   --privileged --network jenkins --network-alias docker \
#   --env DOCKER_TLS_CERTDIR=/certs \
#   --volume jenkins-docker-certs:/certs/client \
#   --volume jenkins-data:/var/jenkins_home \
#   --publish 2376:2376 docker:dind --storage-driver overlay2

# docker build -t myjenkins-blueocean:1.1 $(dirname $0)

# #change --rm to --restart=always
# docker run --name jenkins-blueocean \
#   --restart=always --detach \
#   --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
#   --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
#   --publish 8080:8080 --publish 50000:50000 \
#   --volume jenkins-data:/var/jenkins_home \
#   --volume jenkins-docker-certs:/certs/client:ro \
#   myjenkins-blueocean:1.1

#an error occurs when installed by the way above :
#java.lang.AssertionError: class hudson.security.csrf.DefaultCrumbIssuer is missing its descriptor
#and the jenkins container exits.

docker run \
  -u root \
	--privileged=true \
  -d \
  -p 8086:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=always \
  --volume /etc/localtime:/etc/localtime \
  jenkinsci/blueocean