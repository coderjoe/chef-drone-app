Description
===========

[![Cookbook Version](https://img.shields.io/cookbook/v/drone_app.svg)](https://community.opscode.com/cookbooks/drone-app)
[![Build Status](https://travis-ci.org/coderjoe/chef-drone-app.svg?branch=master)](https://travis-ci.org/coderjoe/chef-drone-app)
[![Code Climate](https://codeclimate.com/github/coderjoe/chef-drone-app/badges/gpa.svg)](https://codeclimate.com/github/coderjoe/chef-drone-app)
[![Dependency Status](https://gemnasium.com/badges/github.com/coderjoe/chef-drone-app.svg)](https://gemnasium.com/github.com/coderjoe/chef-drone-app)

Installs the drone.io docker image with an nginx ssl proxy passthrough with
certificiate registration and renewal managed by letsencrypt.

For more information about drone.io:

* http://readme.drone.io/usage/overview/
* http://docs.drone.io/
* http://drone.io

Changes
=======

## v1.0.0

* Install an nginx ssl proxy in front of a drone.io server both configured via docker.

Requirements
============

## Platform:

* Ubuntu 16.04

Warning! Due to differences in letsencrypt implementations it's highly unlikely
this cookbook will function on other platforms. I don't need anything other than
Ubuntu 16.04, but pull requests are very welcome to resolve this issue.

Attributes
==========

See `attributes/default.rb` for defaults.

* `node['drone']['version']` - The version of drone to install.
* `node['drone']['port']` - The drone.io web port.
* `node['drone']['remote']['driver']` - The drone.io remote driver
* `node['drone']['remote']['config']` - The drone.io remote config
* `node['drone']['database']['driver']` - The drone.io database driver
* `node['drone']['database']['config']` - The drone.io database config

Recipes
=======

default
-------

Installs and configures drone.io with nginx an ssl proxy using letsencrypt
certificates.

Uses:

1. `recipe[drone_app::drone]`
2. `recipe[drone_app::nginx]`
3. `recipe[drone_app::letsencrypt]`
4. `recipe[drone_app::firewall]`

drone
-----

Installs, configures, and runs the drone.io docker container.

nginx
-----

Installs, configures, and runs the nginx docker container as an ssl proxy
for drone.io. Configures itself with self-signed certificates.

The certificates referenced by nginx are controlled via symlinks located at
`/etc/nginx/ssl/<machine fqdn>/`.

`cert.pem` - should link to the site public certificate chain.
`cert.key` - should link to the site's private key.

If the symlinks already exist, this recipe will not create or update them.

letsencrypt
-----------

Installs the letsencrypt executable, configures it for webroot verification,
requests a certificate for the node's FQDN, and updates the site's `cert.pem`
and `cert.key` to point to the newly requested letsencrypt certificates.

firewall
--------

Configure the machine firewall to allow SSH, HTTP, and HTTPS on ports 22, 80,
and 443 repectively.

Usage
=====

To get drone running on a machine, use `recipe[drone_app]`. Once it is installed
and configured nginx will be listening on both port 80 and 443. Nginx will be
configured to proxy to drone as well as provide a web frontend for letsencrypt
renewal requests.

Author
======

Author:: Joe Bauser <coderjoe@coderjoe.net>

License
=======

See the file LICENSE for license information.
