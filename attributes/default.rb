# system_setup
default['system_setup']['timezone']      = 'Europe/Berlin'
default['system_setup']['service_name']  = 'redmine'
default['system_setup']['dest_dir']      = "/srv/#{node['system_setup']['service_name']}"
default['system_setup']['host_ip']       = '127.0.0.1'
