# -*- encoding : utf-8 -*-
require "bundler/capistrano"
require "capistrano/ext/multistage"
require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :rvm_ruby_string, :local
set :rvm_type, :system  # Copy the exact line. I really mean :system here

set :application, "DGLB"
set :repository,  "https://github.com/WaDoku/GLB.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server_ip = "rokuhara.japanologie.kultur.uni-tuebingen.de"

role :web, server_ip                          # Your HTTP server, Apache/etc
role :app, server_ip                          # This may be the same as your `Web` server
role :db,  server_ip, :primary => true        # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false
set :keep_releases, 2

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :fix_ownership, :roles => :app do
    run "chown -R deploy:www-data #{deploy_to}"
  end
end

namespace :db_setup do
  task :create_shared, :roles => :app do
    run "mkdir -p #{shared_path}/db/"
    run "chmod 1777 #{shared_path}/db/"
    run "mkdir -p #{shared_path}/pdf/"
    run "chmod 1777 #{shared_path}/pdf/"
    run "mkdir -p #{shared_path}/index/"
    run "chmod -R 1777 #{shared_path}/index/"
    run "mkdir -p #{shared_path}/SBDJ-Original-JPGs/"
    run "chmod -R 1777 #{shared_path}/SBDJ-Original-JPGs/"
    run "mkdir -p #{shared_path}/docs/"
    run "chmod -R 1777 #{shared_path}/docs/"
    run "mkdir -p #{shared_path}/htms/"
    run "chmod -R 1777 #{shared_path}/htms/"
    run "mkdir -p ##{shared_path}/assets/"
    run "chmod -R 1777 #{shared_path}/assets/"
    run "touch #{shared_path}/assets/.sprockets-manifest.json"
  end

  task :link_shared do
    run "rm -rf #{release_path}/db/sqlite"
    run "ln -nfs #{shared_path}/db #{release_path}/db/sqlite"
    run "rm -rf #{release_path}/public/pdf"
    run "ln -nfs #{shared_path}/pdf #{release_path}/public/pdf"
    run "ln -nfs #{shared_path}/SBDJ-Original-JPGs #{release_path}/public/SBDJ-Original-JPGs"
    run "ln -nfs #{shared_path}/docs #{release_path}/public/docs"
    run "ln -nfs #{shared_path}/htms #{release_path}/public/htms"
    run "rm -rf #{release_path}/index"
    run "ln -nfs #{shared_path}/index #{release_path}/index"
    run "ln -nfs #{shared_path}/newrelic.yml #{release_path}/newrelic.yml"
  end
  task :link_shared_directories do
  end
end

namespace :rake do
  desc "Invoke rake task"
  task :invoke do
    run "cd #{current_path} && bundle exec rake #{ENV['task']}RAILS_ENV=#{rails_env} --trace"
  end
  task :migrate do
    run "cd #{current_path} && bundle exec rake db:migrate #{ENV['task']}RAILS_ENV=#{rails_env} --trace"
  end
  task :assets do
    run "cd #{current_path} && bundle exec rake assets:precompile #{ENV['task']}RAILS_ENV=#{rails_env} --trace"
  end
  task :label do
    run "cd #{current_path} && bundle exec rake db:label_bearbeitungsstand #{ENV['task']}RAILS_ENV=#{rails_env} --trace"
  end
  task :secret do
    run "cd #{current_path} && bundle exec rake secret #{ENV['task']}RAILS_ENV=#{rails_env} --trace"
  end
end

after "deploy:update_code", "db_setup:link_shared"
after "deploy:setup", "db_setup:create_shared"
after "deploy:update_code", "deploy:fix_ownership"
after "deploy:restart", "deploy:cleanup"
after "rake:invoke", "deploy:fix_ownership"
after "rake:migrate", "deploy:fix_ownership"
after "rake:assets", "deploy:fix_ownership"
