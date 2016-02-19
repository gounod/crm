# encoding: utf-8

# config valid only for Capistrano 3.1
lock '3.4.0'
set :ssh_options, { :forward_agent => true }
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache

set :application, 'gounod'
set :repo_url, 'git@github.com:gounod/crm.git'

set :deploy_to, '/home/gounod/website'

set :scm, :git
set :bundle_flags, "--deployment --quiet --binstubs"

set :use_sudo, false
set :rbenv_ruby, '2.2.2'
set :rbenv_path, '/home/gounod/.rbenv'
set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, '2.2.2'      # Defaults to: 'default'

set :linked_files, %w{config/database.yml config/unicorn/production.rb config/unicorn.rb}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
