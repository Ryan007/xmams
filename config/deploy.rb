require 'rvm/capistrano'
require 'bundler/capistrano'

set :user, "ryan"

set :application, "xmams"

set :scm, :git
set :branch, "master"
set :repository,  "git@github.com:Ryan007/xmams.git"
set :deploy_to, "/usr/local/rails-app/www.xm.net/htdocs/#{application}"


default_run_options[:pty] = true  # Must be set for the password prompt

role :app, "www.xm.net"
role :web, "www.xm.net"
role :db,  "www.xm.net", :primary => true

set :deploy_via, :remote_cache
set :scm_verbose, true
set :use_sudo, false

set :rails_env, 'production'
set :rvm_type, :system
set :rvm_ruby_string, '1.9.3-p125@rails3.2.8'
set :rvm_path, '/home/ryan/.rvm'
set :rvm_bin_path, "#{rvm_path}/bin"
set :rvm_lib_path, "#{rvm_path}/lib"
set :rake, "/home/ryan/.rvm/gems/ruby-1.9.3-p125@global/bin/rake"


set :normalize_asset_timestamps, false

# set :web_user, "nobody"

# set :port, 22222
set :bundle_without, [:development]

set :keep_releases, 5

after "deploy:update_code", :bundle_install  
desc 'install prerequisites'  
task :bundle_install, :roles => :app do  
   run "cd #{release_path} && bundle install"
end 

after "deploy:setup", :setup_chown   
desc "change owner from root to user"    
task :setup_chown do    
    run "cd #{current_path}/../../ && #{try_sudo} chown -R #{user}:#{user} #{application}"    
end

after "deploy:cleanup", :cleanup
task :cleanup do
  desc 'cleanup the release'
end



# 常用的任务
# $ cap deploy:setup
# $ cap deploy
# $ cap deploy:migrate
# $ cap deploy:migrations