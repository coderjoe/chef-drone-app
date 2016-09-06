require 'spec_helper'

describe 'drone_app::_nginx_config' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.node.automatic['fqdn'] = 'example.com'
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the conf.d directory' do
      expect(chef_run).to create_directory('/etc/nginx/conf.d')
    end

    it 'creates the snippets directory' do
      expect(chef_run).to create_directory('/etc/nginx/snippets')
    end

    it 'creates the ssl directory' do
      expect(chef_run).to create_directory('/etc/nginx/ssl')
    end

    it 'creates the sites-enabled directory' do
      expect(chef_run).to create_directory('/etc/nginx/sites-enabled')
    end

    it 'creates the sites-available directory' do
      expect(chef_run).to create_directory('/etc/nginx/sites-available')
    end

    it 'creates the nginx config' do
      expect(chef_run).to create_template('/etc/nginx/nginx.conf')
    end

    it 'creates the ssl config snippet config' do
      expect(chef_run).to create_template('/etc/nginx/snippets/ssl-params.conf')
    end

    it 'creates the domain ssl config snippet' do
      expect(chef_run).to create_template(
        '/etc/nginx/snippets/ssl-example.com.conf'
      )
    end

    it 'creates the dhparam.pem file' do
      expect(chef_run).to create_dhparam_pem('/etc/nginx/ssl/dhparam.pem').with(
        key_length: 4096
      )
    end
  end
end
