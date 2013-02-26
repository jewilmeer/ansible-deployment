# Warning
This project is under development and is not yet tested in any other that a
vagrant box. Use at own risk!

# Install guide

This setup includes to following:
- Create a sudo, passwordless user, prevent root login
- Ip-tables, git
- Install ruby, rbenv, ruby-build
- Nginx with passenger module
- Github deployment keys from your home directory with authorized_keys acceptence

# Runned commands

## Install. but ask for ssh-password
ansible-playbook -i ansible_hosts setup.yml -k
ssh password: vagrant

## Further configuration
ansible-playbook -i ansible_hosts tasks/ruby.yml

## Ip-tables setup
http://deangerber.com/blog/2011/09/10/basic-iptables-firewall-configuration/

# Configuration files
Within the variables folder are *.example.yml files. Use these as templates to create
your own configuration.

# Building your own vagrant box with veewee
see http://www.dejonghenico.be/unix/create-vagrant-base-boxes-veewee for details
