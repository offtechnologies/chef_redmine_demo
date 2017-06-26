#
# Cookbook:: chef_redmine_demo
# Recipe:: default
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
# setup apt, basic packages, etc
include_recipe 'chef_redmine_demo::system_setup'
# install and setup mysql
include_recipe 'chef_redmine_demo::mysql_setup'
# install redmine
include_recipe 'chef_redmine_demo::redmine_setup'
# install nginx
include_recipe 'chef_redmine_demo::nginx_setup'
