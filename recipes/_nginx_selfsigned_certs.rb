directory "/etc/nginx/ssl/#{node['fqdn']}" do
  recursive true
end

openssl_x509 "/etc/nginx/ssl/#{node['fqdn']}/selfsigned.pem" do
  common_name node['fqdn']
  org node['fqdn']
  org_unit node['fqdn']
  country 'US'
end

link "/etc/nginx/ssl/#{node['fqdn']}/cert.pem" do
  to "/etc/nginx/ssl/#{node['fqdn']}/selfsigned.pem"
  not_if { ::File.exist? "/etc/nginx/ssl/#{node['fqdn']}/cert.pem" }
end

link "/etc/nginx/ssl/#{node['fqdn']}/cert.key" do
  to "/etc/nginx/ssl/#{node['fqdn']}/selfsigned.key"
  not_if { ::File.exist? "/etc/nginx/ssl/#{node['fqdn']}/cert.key" }
end
