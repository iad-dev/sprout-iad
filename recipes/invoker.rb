RUBY_VERSION = '2.3.1'

# Run setup to get .dev domains
bash 'invoker-install-gems' do
  code <<-BASH
    set -e

    rbenv exec gem install --user-install invoker
    rbenv exec gem install --user-install terminal-notifier
  BASH
end

# invoker directory
directory "#{ENV['HOME']}/.invoker" do
  action :create
  owner node['sprout']['user']
  group 'staff'
end

# Ini file
file "#{ENV['HOME']}/.invoker/iad-apps.ini" do
  action :create
  owner node['sprout']['user']
  group 'staff'
  content <<-INI
[pivots]
directory = ~/workspace/pivots-two
command = bundle exec foreman start -f Procfile.dev
port = 4010
disable_autorun = true

[augur]
directory = ~/workspace/augur
command = bundle exec foreman start -f Procfile.dev
port = 4020
disable_autorun = true

[roster]
directory = ~/workspace/roster
command = rake clean build default
port = 4030
disable_autorun = true

[scavenger]
directory = ~/workspace/scavenger
command = rake clean build default
port = 4040
disable_autorun = true
  INI
end
