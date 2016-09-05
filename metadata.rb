name 'droneio'
maintainer 'Joe Bauser'
maintainer_email 'coderjoe@coderjoe.net'
license 'mit'
description 'Installs/Configures drone.io'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

supports 'ubuntu', '>= 14.04'
supports 'centos', '>= 7.1'
supports 'debian', '>= 8.1'

if respond_to?(:issues_url)
  issues_url 'https://github.com/coderjoe/chef-droneio/issues'
end

if respond_to?(:source_url)
  source_url 'https://github.com/coderjoe/chef-droneio'
end

chef_version '>= 12.6'

depends 'docker', '~> 2.9.6'
