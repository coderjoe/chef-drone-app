require 'spec_helper'

describe 'drone_app::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should install drone' do
      expect(chef_run).to include_recipe('drone_app::drone')
    end

    it 'should set up letsencrypt' do
      expect(chef_run).to include_recipe('drone_app::letsencrypt')
    end

    it 'should install nginx' do
      expect(chef_run).to include_recipe('drone_app::nginx')
    end

    it 'should set up the firewall' do
      expect(chef_run).to include_recipe('drone_app::firewall')
    end
  end
end
