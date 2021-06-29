docker pull gitlab/gitlab-ce
docker run --detach \
  --publish 10443:443 --publish 1080:80 --publish 1022:22 \
  --name gitlab \
  --restart always \
  --volume /mydata/gitlab/config:/etc/gitlab \
  --volume /mydata/gitlab/logs:/var/log/gitlab \
  --volume /mydata/gitlab/data:/var/opt/gitlab \
  gitlab/gitlab-ce:latest

docker exec -i gitlab /bin/bash <<- EOF
	cd /opt/gitlab/bin
		gitlab-rails console <<- END
		u=User.where(id:1).first
		u.password='12345678'
		u.password_confirmation='12345678'
		u.save!
	END   
EOF



