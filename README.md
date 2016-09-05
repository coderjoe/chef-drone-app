Description
===========

[![Cookbook Version](https://img.shields.io/cookbook/v/droneio.svg)](https://community.opscode.com/cookbooks/droneio)
[![Build Status](https://travis-ci.org/coderjoe/chef-droneio.svg?branch=master)](https://travis-ci.org/coderjoe/chef-droneio)
[![Code Climate](https://codeclimate.com/github/coderjoe/chef-droneio/badges/gpa.svg)](https://codeclimate.com/github/coderjoe/chef-droneio)
[![Dependency Status](https://gemnasium.com/badges/github.com/coderjoe/chef-droneio.svg)](https://gemnasium.com/github.com/coderjoe/chef-droneio)

Installs docker, pulls the drone.io docker image, configures drone, and runs
the drone webservice on port 8000.

For more information about drone.io:

* http://readme.drone.io/usage/overview/
* http://docs.drone.io/
* http://drone.io

Changes
=======

## v0.2.0

* Remove runit as the service manager in favor of using the docker service's
restart policies to manage service state.
* Drone config is now explicitly declared via --env, as opposed to being stored
in /etc/drone/dronerc
* The /etc/drone directory is no longer created, and no config is stored.

## v0.1.1

* Add supported platform restrictions to the cookbook, and adjust the kitchen
test suite to test the supported platforms.

## v0.1.0

* Initial implementation and release of drone.io cookbook.

Requirements
============

## Platform:

* Ubuntu 16.04, 15.04, and 14.04
* Debian 8.1 and 8.5
* CentOS 7.1 and 7.2

Other compatible platforms may function, but they have not been tested with
this cookbook.

Attributes
==========

See `attributes/default.rb` for defaults.

* `node['drone']['version']` - The version of drone to install.
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
2. recipe[droneio::drone]

docker
------

Installs docker using the script from `https://get.docker.com` if docker is not
already installed.

drone
-----

Pulls the drone.io docker image and runs the drone container with the configured
drivers and configurations.

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
