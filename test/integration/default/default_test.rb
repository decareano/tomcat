# InSpec test for recipe tomcat::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/
require_relative 'spec_helper'

describe command("curl http://localhost:8080") do
  its('stdout') { should match /Tomcat/ }
end


describe package('java-1.7.0-openjdk-devel')  do
  	it { should be_installed }
end

describe group('tomcat') do
  	it { should exist }
end

describe user('tomcat') do
  	it { should exist }
  	its('group') { should match 'tomcat' }
  	its('home') { should match '/opt/tomcat' }
end

describe file('/opt/tomcat') do
	it { should exist }
	it { should be_directory }
end

describe file('/opt/tomcat/conf') do
	it { should exist }
	its('mode') { should eq 0770 }
end

#execute 'chown -R tomcat webapps/ work/ temp/ logs/'
%w[ webapps/ work/ temp/ logs/ ].each do |path|
	describe file("/opt/tomcat/#{path}") do
		it { should exist }
		it { should be_owned_by 'tomcat'}
	end
end

['net-tools', 'httpd'].each do |pg|
	describe package(pg) do
		it { should be_installed }
	end
end

describe sshd_config do
	its('Protocol') { should cmp 2 }
end

describe sshd_config do
	its('AcceptEnv') { should include('LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES') }
end

describe sshd_config do
  its('Port') { should cmp  22 }
  its('UsePAM') { should eq 'yes' }
  its('ListenAddress') { should eq nil }
  its('HostKey') { should eq [
      '/etc/ssh/ssh_host_rsa_key',
      '/etc/ssh/ssh_host_dsa_key',
      '/etc/ssh/ssh_host_ecdsa_key',
    ] }
end
