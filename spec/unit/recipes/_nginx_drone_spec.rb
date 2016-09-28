require 'spec_helper'

describe 'drone_app::_nginx_drone' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the drone config' do
      expect(chef_run).to create_template(
        '/etc/nginx/sites-available/drone.conf'
      )
    end

    it 'enables the drone config' do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/drone.conf')
        .with(
          to: '/etc/nginx/sites-available/drone.conf',
          link_type: :symbolic
        )
    end
  end
end
