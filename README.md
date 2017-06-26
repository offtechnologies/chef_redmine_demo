# Chef Redmine Demo

##### This is experimental stuff - Do not use in production!
Chef cookbook with recipes needed to deploy Redmine (Ruby on Rails) application to a server running Ubuntu 14.04. Redmine is a flexible project management web application. To learn more on Redmine please visit [this website][redmine]
#### 0.1.0 - 2017-06-26
*  Initial commit
*  latest stable release of Redmine (3.3.3)
*  RMagick and ImageMagick - not available this time...
*  ruby 2.2  - compiled from source
*  mysql - installed via chef-maintained cookbooks
*  WEBrick via init via community-maintained cookbooks
*  Nginx reverse proxy in front of the Rails app
*  basic ufw and ssh hardening via chef-maintained cookbooks
#### Requirements
* Chef Development Kit Version: 1.4.3
* Chef-client version: 12.19.36
* berks version: 5.6.4
* kitchen version: 1.16.0
* Vagrant 1.8.5
#### Usage
    git clone https://github.com/offtechnologies/chef_redmine_demo
    cd chef_redmine_demo
    kitchen converge

[redmine]:<https://www.redmine.org/>
