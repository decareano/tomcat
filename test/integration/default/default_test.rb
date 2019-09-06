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


