# Install guide

This setup includes to following:
- Create a sudo, passwordless user, prevent root login
- Ip-tables, git
- Install ruby, rbenv, ruby-build
- Nginx with passenger module
- Github deployment keys from your home directory with authorized_keys acceptence

# Runned commands

## install. but ask for ssh-password
ansible-playbook -i ansible_hosts setup.yml -k
ssh password: vagrant

## Further configuration
ansible-playbook -i ansible_hosts tasks/ruby.yml

## ip-tables setup
http://deangerber.com/blog/2011/09/10/basic-iptables-firewall-configuration/
