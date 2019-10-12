#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved

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
remote_file 'apache-tomcat-8.5.46.tar.gz' do
	source 'https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.46/bin/apache-tomcat-8.5.46.tar.gz'
end

directory '/opt/tomcat' do
	action :create
end

#execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

execute 'tar' do
  command 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  cwd '/'
  not_if { File.exists?("/opt/tomcat") }
end

directory '/opt/tomcat/conf' do
	mode '0770'
end


tomcat_dir = '/opt/tomcat'
execute 'tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

# execute 'group_idem' do
# 	command 'chgrp -R tomcat /opt/tomcat/conf'
# 	cwd '/opt/tomcat/conf'
# 	not_if 'grep tomcat /opt/tomcat/conf', :group => 'tomcat'
# end
execute 'chmod g+r /opt/tomcat/conf/*'
#execute 'chmod g+r /opt/tomcat/conf/*'
# execute 'user_idem' do
# 	command 'chmod g+r /opt/tomcat/conf/*'
# 	cwd '/opt/tomcat/conf/*'
# 	not_if 'grep tomcat /opt/tomcat/conf/*', :user => 'tomcat'
# end
# execute 'mycommand' do
#   command 'chgrp -R tomcat /opt/tomcat/conf'
#   not_if 'grep tomcat /opt/tomcat/conf', :group => 'tomcat'
# end

#execute 'chmod g+r /opt/tomcat/conf/*'
#execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
execute 'systemctl daemon-reload'

# directory '/opt/tomcat/conf' do
# 	mode '0770'
# end

%w[bin webapps work temp logs conf lib].each do |sub_dir|
  execute "chown -R tomcat #{tomcat_dir}/#{sub_dir}"
end

template '/etc/systemd/system/tomcat.service' do
	source 'tomcat.service.erb'
end

service 'tomcat' do
	action [:start, :enable]
end

package 'httpd' do
	action :install
end
