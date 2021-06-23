#!/bin/bash
#1.install gem 
yum install -y rubygems

#2.update gem source
gem sources -a http://mirrors.aliyun.com/rubygems/ 
gem sources -r https://rubygems.org/ 
gem sources -u

#3.install rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || \
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

#4.install ruby
rvm install 2.6.3
ruby -v
