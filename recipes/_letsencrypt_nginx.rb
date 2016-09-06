directory 'letsencrypt nginx ssl directory' do
  path "/etc/nginx/ssl/#{node['fqdn']}"
  recursive true
end

link 'letsencrypt cert.pem' do
  target_file "/etc/nginx/ssl/#{node['fqdn']}/cert.pem"
  to "/etc/letsencrypt/live/#{node['fqdn']}/fullchain.pem"
end

link 'letsencrypt cert.key' do
  target_file "/etc/nginx/ssl/#{node['fqdn']}/cert.key"
  to "/etc/letsencrypt/live/#{node['fqdn']}/privkey.pem"
  notifies :run, 'execute[restart nginx]', :immediately
end

execute 'restart nginx' do
  command 'docker restart nginx'
  action :nothing
end
