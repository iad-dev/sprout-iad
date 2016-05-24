RUBY_VERSION = '2.3.0'

# Run setup to get .dev domains
bash 'invoker-install-gems' do
  code <<-BASH
    set -e

    sudo -s "chruby-exec #{RUBY_VERSION} -- bash -c 'gem install invoker'"
    chown pivotal:staff /Users/pivotal/.rubies/ruby-#{RUBY_VERSION}/bin/invoker
    chruby-exec #{RUBY_VERSION} -- gem install terminal-notifier
  BASH
end

bash 'invoker-setup' do
  code "sudo -s 'chruby-exec #{RUBY_VERSION} -- invoker setup'"
end

# Ini file
file "#{ENV['HOME']}/.invoker/iad-apps.ini" do
  action :create
  content <<-INI
[meeple-config]
directory = ~/workspace/meeple-config
command = rake clean build default
port = 8081

[meeple-auth]
directory = ~/workspace/meeple-auth
command = until $(curl --output /dev/null --silent --head --fail http://meeple-config.dev/health); do sleep 1; done && rake clean build default
port = 8082

[meeple-people]
directory = ~/workspace/meeple-people
command = until $(curl --output /dev/null --silent --head --fail http://meeple-auth.dev/health); do sleep 1; done && rake clean build default
port = 8083

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
  INI
end
