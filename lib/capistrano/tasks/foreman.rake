# coding: utf-8
namespace :foreman do

  desc 'Export the Procfile'
  task :export do
    on roles fetch(:foreman_roles) do
      within release_path do
        use_sudo = fetch(:foreman_use_sudo, false) ? 'sudo' : ''
        command = fetch(:foreman_use_binstubs, false) ? 'bin/foreman' : 'bundle exec foreman'

        opts = { 
          app: fetch(:application),
          log: File.join(shared_path, 'log'),
        }.merge fetch(:foreman_options, {})

        execute "#{use_sudo} #{command} export",
          fetch(:foreman_template),
          fetch(:foreman_export_path),
          opts.map { |opt, value| "--#{opt}='#{value}'" }.join(' ')
      end
    end
  end

  desc 'Start the application services'
  task :start do
    on roles fetch(:foreman_roles) do
      use_sudo = fetch(:foreman_use_sudo, false) ? 'sudo' : ''
      options = fetch(:foreman_options)
      app = options[:app] || fetch(:application)
      execute "#{use_sudo} service #{app} start"
    end
  end

  desc 'Stop the application services'
  task :stop do
    on roles fetch(:foreman_roles) do
      use_sudo = fetch(:foreman_use_sudo, false) ? 'sudo' : ''
      options = fetch(:foreman_options)
      app = options[:app] || fetch(:application)
      execute "#{use_sudo} service #{app} stop"
    end
  end

  desc 'Restart the application services'
  task :restart do
    on roles fetch(:foreman_roles) do
      use_sudo = fetch(:foreman_use_sudo, false) ? 'sudo' : ''
      options = fetch(:foreman_options)
      app = options[:app] || fetch(:application)
      execute "#{use_sudo} service #{app} restart"
    end
  end

end

namespace :load do
  task :defaults do
    set :foreman_use_sudo, fetch(:foreman_use_sudo, false)
    set :foreman_use_binstubs, fetch(:foreman_use_binstubs, false)
    set :foreman_template, fetch(:foreman_template, 'upstart')
    set :foreman_export_path, fetch(:foreman_export_path, '/etc/init/sites')
    set :foreman_roles, fetch(:foreman_roles, :all)
  end
end
