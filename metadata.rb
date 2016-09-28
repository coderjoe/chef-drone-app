name 'drone_app'
maintainer 'Joe Bauser'
maintainer_email 'coderjoe@coderjoe.net'
license 'mit'
description 'Installs drone.io behind an nginx ssl proxy with letsencrypt certs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/coderjoe/chef-drone-app'
issues_url 'https://github.com/coderjoe/chef-drone-app/issues'
version '1.0.1'

chef_version '>= 12.6'

depends 'hostname'
depends 'firewall', '~> 2.5.2'
depends 'openssl', '~> 5.0.1'
depends 'docker', '~> 2.9.6'
depends 'drone', '~> 3.1.2'

supports 'ubuntu', '>= 16.04'
