package 'openssl'

directory('/etc/nginx/conf.d') do
  recursive true
end

directory('/etc/nginx/ssl') do
  recursive true
end

openssl_dhparam('/etc/nginx/ssl/dhparam.pem') do
  key_length 4096
end

directory('/etc/nginx/sites-enabled') do
  recursive true
end

directory('/etc/nginx/sites-available') do
  recursive true
end

directory('/etc/nginx/snippets') do
  recursive true
end

template('/etc/nginx/nginx.conf') do
  source 'nginx.conf.erb'
end

template('/etc/nginx/snippets/ssl-params.conf') do
  source 'ssl-params.conf.erb'
end

template("/etc/nginx/snippets/ssl-#{node['fqdn']}.conf") do
  source 'ssl-domain.conf.erb'
end
