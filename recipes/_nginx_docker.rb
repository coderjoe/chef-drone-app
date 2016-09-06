docker_image 'nginx' do
  repo 'nginx'
  tag 'stable'
  action :pull_if_missing
end

docker_container 'nginx' do
  repo 'nginx'
  tag 'stable'
  restart_policy 'always'

  port ['80:80', '443:443']

  links ['drone:drone']

  volumes ['/etc/nginx/nginx.conf:/etc/nginx/nginx.conf',
           '/etc/nginx/ssl:/etc/nginx/ssl',
           '/etc/nginx/snippets:/etc/nginx/snippets',
           '/etc/nginx/conf.d:/etc/nginx/conf.d',
           '/etc/nginx/sites-enabled:/etc/nginx/sites-enabled',
           '/etc/nginx/sites-available:/etc/nginx/sites-available',
           '/etc/letsencrypt:/etc/letsencrypt',
           '/srv:/srv']

  action [:stop, :delete, :run]
end
