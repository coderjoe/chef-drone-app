#
# Cookbook Name:: droneio
# Spec:: docker
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

describe 'droneio::docker' do
  context 'When running on Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    context 'when docker is already installed' do
      before do
        stub_command('which docker').and_return true
      end

      it 'should not install docker via script' do
        expect(chef_run)
          .to_not create_docker_installation_script('get.docker.com')
      end
    end

    context 'when docker is not installed' do
      before do
        stub_command('which docker').and_return false
      end

      it 'should install docker via script' do
        expect(chef_run).to create_docker_installation_script('get.docker.com')
      end

      it 'should purge the old lxc-docker package' do
        expect(chef_run).to purge_package('lxc-docker')
      end

      it 'should create the docker group' do
        expect(chef_run).to create_group('docker')
      end

      it 'should start the docker service' do
        expect(chef_run).to start_service('docker')
      end

      it 'should enable the docker service on boot' do
        expect(chef_run).to enable_service('docker')
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
    end
  end
end
