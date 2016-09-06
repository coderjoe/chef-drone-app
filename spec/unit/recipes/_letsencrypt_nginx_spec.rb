require 'spec_helper'

describe 'drone_app::_letsencrypt_nginx' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.node.automatic['fqdn'] = 'example.com'
      runner.node.override['letsencrypt']['contact'] = 'fake@example.com'
      runner.node.override['letsencrypt']['staging'] = false
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the nginx ssl directory' do
      expect(chef_run).to create_directory(
        'letsencrypt nginx ssl directory'
      ).with(
        path: '/etc/nginx/ssl/example.com',
        recursive: true
      )
    end

    it 'links cert.pem to the letsencrypt fullchain.pem' do
      expect(chef_run).to create_link('letsencrypt cert.pem').with(
        target_file: '/etc/nginx/ssl/example.com/cert.pem',
        to: '/etc/letsencrypt/live/example.com/fullchain.pem'
      )
    end

    it 'links cert.key to the self signed key' do
      expect(chef_run).to create_link('letsencrypt cert.key').with(
        target_file: '/etc/nginx/ssl/example.com/cert.key',
        to: '/etc/letsencrypt/live/example.com/privkey.pem'
      )
    end

    it 'should restart the nginx docker image' do
      expect(chef_run.link('/etc/nginx/ssl/example.com/cert.key'))
        .to notify('execute[restart nginx]').to(:run).immediately
    end
  end
end
