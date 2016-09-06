include_recipe 'drone::default'

resources('docker_container[drone]').port "#{node['drone']['port']}:8000"
