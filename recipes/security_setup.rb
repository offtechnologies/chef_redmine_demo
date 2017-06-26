#
# Cookbook:: chef_tracks_demo_2
# Recipe:: security_setup
#
# Copyright:: 2017, OFF Technologies, All Rights Reserved.
###########################################
# Setup and configure basic server security
###########################################

# configure unattended-upgrades, default value (at default precedence) is:
#
# {
#  'security'  => true,
#  'updates'   => false,
#  'proposed'  => false,
#  'backports' => false
# }

include_recipe 'unattended-upgrades::default'

# configure fail2ban
include_recipe 'fail2ban::default'
node.default['fail2ban']['services'] = {
  'ssh' => {
    'enabled' => 'true',
    'port' => 'ssh',
    'filter' => 'sshd',
    'logpath' => node['fail2ban']['auth_log'],
    'maxretry' => '6',
  },
  'ssh-ddos' => {
    'enabled' => 'true',
    'port' => 'ssh',
    'filter' => 'sshd-ddos',
    'logpath' => node['fail2ban']['auth_log'],
    'maxretry' => '6',
  },
  'nginx-http-auth' => {
    'enabled' => 'true',
    'port' => 'http',
    'filter' => 'nginx-http-auth',
    'logpath' => node['fail2ban']['auth_log'],
    'maxretry' => '6',
  },
}

# configure sshd
include_recipe 'openssh::default'
node.default['openssh']['server']['permit_root_login'] = 'no'
node.default['openssh']['server']['password_authentication'] = 'yes' # for tests only

# configure firewall
# install and configure firewall
include_recipe 'firewall::default'
ports = [22, 80, 443]
firewall_rule "open ports #{ports}" do
  port ports
end
