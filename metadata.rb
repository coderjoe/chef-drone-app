name 'droneio'
maintainer 'Joe Bauser'
maintainer_email 'coderjoe@coderjoe.net'
license 'mit'
description 'Installs/Configures drone.io'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

issues_url 'https://github.com/coderjoe/chef-droneio/issues' if respond_to?(:issues_url)
source_url 'https://github.com/coderjoe/chef-droneio' if respond_to?(:source_url)

chef_version ">= 12.6"

depends 'runit', '~> 2.0.0'
depends 'docker', '~> 2.9.6'