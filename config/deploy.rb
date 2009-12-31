set :application, "nuve_wishlist"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/deployer/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
default_run_options[:pty] = true
set :scm, :git
set :repository, "git@github.com:josh6847/nuve_wishlist.git"
set :deploy_via, :remote_cache
set :branch, "master"
set :git_shallow_clone, 1
#set :copy_cache, "/home/deployer/apps/all_bout_texas/shared/cached-copy/all_bout_texas/"

# abt
role :app, "174.143.241.236"
role :web, "174.143.241.236"
role :db,  "174.143.241.236", :primary => true

set :scm_username, "deployer"
set :scm_passphrase, "dep4Udude"

set :user, "deployer"
set :runner, "deployer"

namespace :deploy do 
    task :copy_database_configuration do 
    production_db_config = "/home/deployer/config/nuve_wishlist_database.yml" 
    run "cp #{production_db_config} #{release_path}/config/database.yml" 
  end
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "if [ -d \"#{current_path}/tmp\" ]; then touch #{current_path}/tmp/restart.txt fi"
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
   
  after "deploy:update_code", "deploy:copy_database_configuration" 
  after "deploy:update_code", "deploy:restart"

end 
