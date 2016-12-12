ROOT_PASSWORD = node['sprout']['mysql']['root_password']
USERNAME = 'pivotal'

execute 'create a pivotal user with no password' do
  command "mysql -uroot -p#{ROOT_PASSWORD} -e \"create user '#{USERNAME}' identified by ''\""
  not_if "mysql -u#{USERNAME} -p -e 'show databases'"
end

execute 'give the pivotal user root permissions' do
  command "mysql -uroot -p#{ROOT_PASSWORD} -e \"grant all privileges on *.* to '#{USERNAME}'\""
end
