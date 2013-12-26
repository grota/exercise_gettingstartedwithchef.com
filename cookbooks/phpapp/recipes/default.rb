#
# Cookbook Name:: phpapp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apache2'
include_recipe 'mysql::client'
include_recipe 'mysql::server'
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"
include_recipe "mysql::ruby"

apache_site "default" do
    enable false
end

mysql_database node['phpapp']['database'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['phpapp']['db_username'] do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['phpapp']['db_password']
  database_name node['phpapp']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

wordpress_site node["phpapp"]["server_name"] do
  path          "/var/www/phpapp"
  database      node["phpapp"]["database"]
  db_username   node["phpapp"]["db_username"]
  db_password   node["phpapp"]["db_password"]
  template      "site.conf.erb"
end
