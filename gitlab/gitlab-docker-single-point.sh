############################################通用##################################################################
set -ex
[[ $SYSTEM_INSTALL_AND_CONFIG == "" ]] && export SYSTEM_INSTALL_AND_CONFIG=$(find / -name system-install-and-config)
set -u
exec 2>$SYSTEM_INSTALL_AND_CONFIG/log
############################################通用##################################################################

bash $SYSTEM_INSTALL_AND_CONFIG/docker-install.sh

docker pull gitlab/gitlab-ce
docker run --detach \
  --publish 10443:443 --publish 1080:80 --publish 1022:22 \
  --name gitlab \
  --restart always \
  --volume /mydata/gitlab/config:/etc/gitlab \
  --volume /mydata/gitlab/logs:/var/log/gitlab \
  --volume /mydata/gitlab/data:/var/opt/gitlab \
  --volume /etc/localtime:/etc/localtime \
  gitlab/gitlab-ce:latest

sleep 120s

docker exec -i gitlab /bin/bash <<- EOF
cd /opt/gitlab/bin
gitlab-rails console <<- END
u=User.where(id:1).first
u.password='12345678'
u.password_confirmation='12345678'
u.save!
END   
EOF



