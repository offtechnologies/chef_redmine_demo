#
# Cookbook:: chef_redmine_demo
# Recipe:: nginx_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

#########################################
# Setup and configure nginx reverse proxy
#########################################

site         = node['system_setup']['service_name']
root_dir     = "#{node['system_setup']['dest_dir']}/public"
default_path = '/etc/nginx/sites-enabled/default'

# install standart package
package 'nginx'

# delete default site
file default_path do
  action :delete
end

# start nginx service
service 'nginx' do
  supports [:status, :restart]
  action :start
end

# add new nginx config from template and restart nginx
template "/etc/nginx/sites-enabled/#{site}" do
  source 'nginx.conf.erb'
  mode 0644
  owner node['user_setup']['user']
  group node['user_setup']['user']
  variables(
    site: site,
    root_dir: root_dir,
    server: node['system_setup']['host_ip']
  )
  notifies :restart, 'service[nginx]', :delayed
end
