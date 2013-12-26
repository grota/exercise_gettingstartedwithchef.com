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

sites = data_bag("wp-sites")

sites.each do |site|
  opts = data_bag_item("wp-sites", site)

  mysql_database opts['database'] do
    connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
    action :create
  end

  mysql_database_user opts['db_username'] do
    connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
    password opts['db_password']
    database_name opts['database']
    privileges [:select,:update,:insert,:create,:delete]
    action :grant
  end

  wordpress_site opts["host"] do
    path          "/var/www/" + opts['host']
    database      opts["database"]
    db_username   opts["db_username"]
    db_password   opts["db_password"]
    template      "site.conf.erb"
  end
end

