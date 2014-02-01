require 'bundler/capistrano'
require 'new_relic/recipes'
# require 'sidekiq/capistrano'
load 'deploy/assets'

set :application, "tvguide"
set :repository,  "git@github.com:jewilmeer/tv-guide.git"

set :deploy_to, "/var/www/#{application}"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, :master
set :deploy_via, :remote_cache

server 'netflikker.nl', :app, :web, :db, :primary=>true
set :user, :jewilmeer
set :keep_releases, 3

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_shared do
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/config/newrelic.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/config/exceptional.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/config/sidekiq.yml #{release_path}/config/"
    run "ln -sf #{shared_path}/uploads #{release_path}/public/"
  end
end

before "deploy:finalize_update", "deploy:symlink_shared"


# sidekiq hooks
after "deploy:stop",    "sidekiq:stop"
after "deploy:start",   "sidekiq:start"
before "deploy:restart", "sidekiq:restart"

# We need to run this after our collector mongrels are up and running
# This goes out even if the deploy fails, sadly
after "deploy", "newrelic:notice_deployment"
after "deploy:update", "newrelic:notice_deployment"
after "deploy:migrations", "newrelic:notice_deployment"
after "deploy:cold", "newrelic:notice_deployment"

namespace :sidekiq do
  desc "Stop sidekiq"
  task :stop do
    run "#{try_sudo} service sidekiq stop"
  end

  task :start do
    run "#{try_sudo} service sidekiq start"
  end

  task :restart do
    run "#{try_sudo} service sidekiq restart"
  end
end
