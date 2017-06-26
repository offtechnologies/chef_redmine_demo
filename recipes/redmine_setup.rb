#
# Cookbook:: chef_redmine_demo
# Recipe:: redmine_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.

#######################################################################################################
# redmine_setup - requires application_ruby and application_git cookbooks in metadata.rb ....
########################################################################################################

db_secret       = data_bag_item('passwords', 'mysql')
token_secret    = data_bag_item('passwords', 'token')
myapp           = node['system_setup']['dest_dir']

application myapp.to_s do
  poise_service_user node['user_setup']['user']

  # git clone redmine (latest stable) repo
  load = git myapp.to_s do
    destination node['system_setup']['dest_dir']
    repository node['redmine_setup']['redmine_repo']
    reference node['redmine_setup']['redmine_version']
  end

  # install Ruby
  ruby_runtime myapp.to_s do
    provider :ruby_build
    version node['ruby_setup']['ruby_version']
  end

  template 'Gemfile' do
    source 'Gemfile.erb'
    mode '0755'
    only_if { load.updated_by_last_action? }
  end

  # bundle install - first run to generate gem.lock
  bash 'boundle install' do
    cwd node['system_setup']['dest_dir']
    # user node['user_setup']['user']
    # environment PATH: '/opt/ruby_build/builds/srv/redmine/bin/'
    code <<-EOC
      /opt/ruby_build/builds/srv/redmine/bin/bundle install --quiet --no-deployment --without development test rmagick
    EOC
    only_if { load.updated_by_last_action? }
  end

  bundle_install myapp.to_s do
    path node['system_setup']['dest_dir']
    deployment true
    without %w(development test rmagick)
  end

  # database settings for rails
  rails myapp.to_s do
    database(database: node['mysql_setup']['dbname'],
             adapter: node['mysql_setup']['dbadapter'],
             username: node['mysql_setup']['dbadmin'],
             password: db_secret['admin_password'],
             host: node['mysql_setup']['dbhost'])
    secret_token token_secret['token_value']
    migrate true
  end

  # init service settings
  poise_service "#{node['system_setup']['service_name']}-web" do
    command 'bundle exec rails server -e production'
    directory node['system_setup']['dest_dir']
    environment PATH: '/opt/ruby_build/builds/srv/redmine/bin/'
  end
end
