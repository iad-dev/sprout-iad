dmg_package "Alfred 2" do
  source "https://cachefly.alfredapp.com/Alfred_2.8.6_441.dmg"
  volumes_dir "Alfred"
  action :install
  owner node['sprout']['user']
end
