include_recipe 'drone_app::_nginx_selfsigned_certs'
include_recipe 'drone_app::_nginx_config'
include_recipe 'drone_app::_nginx_drone'
include_recipe 'drone_app::_nginx_docker'
