Description
===========

Installs docker, pulls the drone.io docker image, configures drone,
and monitors the drone.io container via runit.

For more information about drone.io:

* http://readme.drone.io/usage/overview/
* http://docs.drone.io/
* http://drone.io

Changes
=======

## v0.1.0

Roadmap
-------

* Initial implementation and release of drone.io cookbook.

Requirements
============

## Platform:

* Ubuntu 16.04

Attributes
==========

See `attributes/default.rb` for defaults.


* `node['drone']['remote']['driver']` - The drone.io remote driver
* `node['drone']['remote']['config']` - The drone.io remote config
* `node['drone']['database']['driver']` - The drone.io database driver
* `node['drone']['database']['config']` - The drone.io database config

Recipes
=======

default
-------

Installs, configures, and runs drone.io. This recipe calls the following:

1. recipe[droneio::docker]
2. recipe[droneio::install_drone]
3. recipe[droneio::runit]

docker
------

Installs docker using the script from `https://get.docker.com` if docker is not
already installed.

install_drone
-------------

Pulls the drone.io docker image drone/drone:0.4 and saves drone.io configuration
environment variables to `/etc/drone/dronerc`.

runit
-----

Installs the runit process monitor, and configures the drone.io container as
a monitored service.

Usage
=====

To get drone running on a machine, use `recipe[droneio]`. Once it is installed
and configured drone will be listening on port 8000.

Author
======

Author:: Joe Bauser <coderjoe@coderjoe.net>

License
=======

See the file LICENSE for license information.
