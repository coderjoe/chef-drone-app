package 'letsencrypt'

directory "/srv/letsencrypt/#{node['fqdn']}" do
  recursive true
end

le_server = node['letsencrypt']['server']

letsencrypt = ['letsencrypt certonly']
letsencrypt.push('--non-interactive')
letsencrypt.push("--server #{le_server}") unless le_server.nil?
letsencrypt.push '--webroot'
letsencrypt.push '--agree-tos'
letsencrypt.push "-m #{node['letsencrypt']['contact']}"
letsencrypt.push "-w /srv/letsencrypt/#{node['fqdn']}"
letsencrypt.push "-d #{node['fqdn']}"

execute('letsencrypt_webroot') do
  command letsencrypt.join(' ')
end

cron('letsencrypt_autorenew') do
  command 'letsencrypt renew'
  hour '1,13'
  minute Random.new.rand(0..59)
end

include_recipe 'drone_app::_letsencrypt_nginx'
