#
# Cookbook Name:: droneio
# Spec:: drone
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

require 'spec_helper'

describe 'droneio::drone' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.default['drone']['remote']['driver'] = 'coffee'
      runner.node.default['drone']['remote']['config'] = 'http://example.com/fake/site'
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'pulls the drone image' do
      expect(chef_run).to pull_if_missing_docker_image('drone').with(
        repo: 'drone/drone',
        tag: '0.4'
      )
    end

    it 'stops the existing drone container' do
      expect(chef_run).to stop_docker_container('drone')
    end

    it 'deletes the existing drone container' do
      expect(chef_run).to delete_docker_container('drone')
    end

    it 'runs the drone container' do
      expect(chef_run).to run_docker_container('drone').with(
        repo: 'drone/drone',
        tag: '0.4',
        restart_policy: 'always',
        port: '8000:8000',
        host_name: 'drone',
        env: [
          'REMOTE_DRIVER=coffee',
          'REMOTE_CONFIG=http://example.com/fake/site',
          'DATABASE_DRIVER=sqlite3',
          'DATABASE_CONFIG=/var/lib/drone/drone.sqlite'
        ]
      )
    end
  end

  context 'When a custom port is provided, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.default['drone']['remote']['driver'] = 'coffee'
      runner.node.default['drone']['remote']['config'] = 'http://example.com/fake/site'
      runner.node.override['drone']['port'] = 1234
      runner.converge(described_recipe)
    end

    it 'uses the custom port' do
      expect(chef_run).to run_docker_container('drone').with(
        port: '1234:8000'
      )
    end
  end
end
