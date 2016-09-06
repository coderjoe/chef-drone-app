template('/etc/nginx/sites-available/drone.conf') do
  source 'nginx-drone.conf.erb'
end

link('/etc/nginx/sites-enabled/drone.conf') do
  to '/etc/nginx/sites-available/drone.conf'
  link_type :symbolic
end
