require 'spec_helper'

describe 'drone_app::nginx' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.node.automatic['fqdn'] = 'example.com'
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the nginx selfsigned certificate recipe' do
      expect(chef_run).to include_recipe('drone_app::_nginx_selfsigned_certs')
    end

    it 'includes the nginx config private recipe' do
      expect(chef_run).to include_recipe('drone_app::_nginx_config')
    end

    it 'includes the nginx docker private recipe' do
      expect(chef_run).to include_recipe('drone_app::_nginx_docker')
    end

    it 'includes the nginx drone private recipe' do
      expect(chef_run).to include_recipe('drone_app::_nginx_drone')
    end
  end
end
