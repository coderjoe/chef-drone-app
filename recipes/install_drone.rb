#
# Cookbook Name:: droneio
# Recipe:: install_drone
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Joe Bauser
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

docker_image('drone/drone') do
  tag '0.4'
  action :pull
end

directory('/etc/drone') do
  mode '0750'
  action :create
end

remote_config = {
  driver: node['drone']['remote']['driver'],
  config: node['drone']['remote']['config']
}

database_config = nil

unless node['drone']['database']['driver'].nil?
  database_config = {
    driver: node['drone']['database']['driver'],
    config: node['drone']['database']['config']
  }
end

template '/etc/drone/dronerc' do
  source 'dronerc.erb'
  mode '0640'

  variables config: {
    remote: remote_config,
    database: database_config
  }
end
