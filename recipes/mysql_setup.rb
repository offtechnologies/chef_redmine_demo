#
# Cookbook:: chef_redmine_demo
# Recipe:: mysql_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

# ############################################################################################
# database setup - requires chef-maintained:
# mysql, mysql2_chef_gem, database cookbooks
# referenced from:
# https://learn.chef.io/modules/create-a-web-app-cookbook/ubuntu/virtualbox/configure-mysql#/
# ############################################################################################

# Load MySQL passwords from the 'passwords' data bag - located in test/fixtures for local tests - do no use in prod
db_secret = data_bag_item('passwords', 'mysql')

# Configure the MySQL client.
mysql_client node['system_setup']['service_name'] do
  action :create
end

# Configure the MySQL service.
mysql_service node['system_setup']['service_name'] do
  initial_root_password db_secret['root_password']
  action [:create, :start]
end

# Install the mysql2 Ruby gem.
mysql2_chef_gem node['system_setup']['service_name'] do
  action :install
end

mysql_connection_info = {
  host: node['mysql_setup']['dbhost'],
  username: 'root',
  password: db_secret['root_password'],
}

# Create the database instance.
mysql_database node['mysql_setup']['dbname'] do
  connection mysql_connection_info
  action :create
end

# Add a database user.
mysql_database_user node['mysql_setup']['dbadmin'] do
  connection mysql_connection_info
  password db_secret['admin_password']
  database_name node['mysql_setup']['dbname']
  host node['mysql_setup']['dbhost']
  action [:create, :grant]
end
