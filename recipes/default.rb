#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

package 'java-1.7.0-openjdk-devel'

group 'tomcat'

#execute 'sudo groupadd tomcat'
user 'tomcat' do 
  manage_home false
  shell '/bin/nologin'
  group 'tomcat'
  home '/opt/tomcat'
end

#https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.45/
remote_file 'apache-tomcat-8.5.45.tar.gz' do
	source 'https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.45/bin/apache-tomcat-8.5.45.tar.gz'
end

directory '/opt/tomcat' do
	# action :create
end

execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
execute 'chgrp -R tomcat /opt/tomcat/conf'
execute 'chmod g+r /opt/tomcat/conf/*'
execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
execute 'systemctl daemon-reload'

directory '/opt/tomcat/conf' do
	mode '0070'
end

template '/etc/systemd/system/tomcat.service' do
	source 'tomcat.service.erb'
end

service 'tomcat' do
	action [:start, :enable]
end
