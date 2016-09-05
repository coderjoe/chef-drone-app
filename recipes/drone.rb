#
# Cookbook Name:: droneio
# Recipe:: drone
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

docker_image('drone') do
  repo 'drone/drone'
  tag node['drone']['version']
  action :pull_if_missing
end

docker_container('drone') do
  repo 'drone/drone'
  tag node['drone']['version']
  port "#{node['drone']['port']}:8000"
  restart_policy 'always'
  host_name 'drone'
  env([
        "REMOTE_DRIVER=#{node['drone']['remote']['driver']}",
        "REMOTE_CONFIG=#{node['drone']['remote']['config']}",
        "DATABASE_DRIVER=#{node['drone']['database']['driver']}",
        "DATABASE_CONFIG=#{node['drone']['database']['config']}"
      ])
  volumes([
            '/var/lib/drone:/var/lib/drone',
            '/var/run/docker.sock:/var/run/docker.sock'
          ])
  action [:stop, :delete, :run]
end
