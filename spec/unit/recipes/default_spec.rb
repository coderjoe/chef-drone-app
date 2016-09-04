#
# Cookbook Name:: droneio
# Spec:: default
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

describe 'droneio::default' do
  context 'When running on Ubuntu 16.04 xenial' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.node.default['drone']['remote']['driver'] = 'fakedriver'
      runner.node.default['drone']['remote']['config'] = 'https://example.com/fakeconfig'
      runner.converge(described_recipe)
    end

    before do
      stub_command('which docker').and_return false
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should include the docker recipe' do
      expect(chef_run).to include_recipe('droneio::docker')
    end

    it 'should install drone' do
      expect(chef_run).to include_recipe('droneio::install_drone')
    end

    it 'should setup runit services' do
      expect(chef_run).to include_recipe('droneio::runit')
    end
  end
end
