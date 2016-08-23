RUBY_VERSION = '2.3.0'

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
  owner 'pivotal'
  group 'staff'
end

# Ini file
file "#{ENV['HOME']}/.invoker/iad-apps.ini" do
  action :create
  owner 'pivotal'
  group 'staff'
  content <<-INI
[meeple-config]
directory = ~/workspace/meeple-config
command = rake clean build default
port = 8081

[meeple-auth]
directory = ~/workspace/meeple-auth
command = until $(curl --output /dev/null --silent --head --fail http://localhost:8081/health); do sleep 1; done && rake clean build default
port = 8082

[meeple-people]
directory = ~/workspace/meeple-people
command = until $(curl --output /dev/null --silent --head --fail http://localhost:8082/health); do sleep 1; done && rake clean build default
port = 8083

[meeple-api]
directory = ~/workspace/meeple-api
command = until $(curl --output /dev/null --silent --head --fail http://meeple-auth.dev/health); do sleep 1; done && rake clean build default
port = 8084

[allocations]
directory = ~/workspace/allocations
command = foreman start
port = 4000
disable_autorun = true

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
