require 'spec_helper'

describe 'drone_app::_nginx_selfsigned_certs' do
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

    it 'creates the certificate directory' do
      expect(chef_run).to create_directory '/etc/nginx/ssl/example.com'
    end

    it 'generates the self signed key' do
      expect(chef_run).to create_x509_certificate(
        '/etc/nginx/ssl/example.com/selfsigned.pem'
      ).with(
        common_name: 'example.com',
        org: 'example.com',
        org_unit: 'example.com',
        country: 'US'
      )
    end

    context 'when the links do not already exist' do
      before(:each) do
        allow(::File).to receive(:exist?).and_call_original
        %w(
          /etc/nginx/ssl/example.com/cert.pem
          /etc/nginx/ssl/example.com/cert.key
        ).each do |file|
          allow(::File).to receive(:exist?).with(file).and_return false
        end
      end

      it 'links certificate.pem to the self signed cert' do
        expect(chef_run).to create_link(
          '/etc/nginx/ssl/example.com/cert.pem'
        ).with(
          to: '/etc/nginx/ssl/example.com/selfsigned.pem'
        )
      end

      it 'links privatekey.pem to the self signed key' do
        expect(chef_run).to create_link(
          '/etc/nginx/ssl/example.com/cert.key'
        ).with(
          to: '/etc/nginx/ssl/example.com/selfsigned.key'
        )
      end
    end

    context 'when the links already exist' do
      before(:each) do
        allow(::File).to receive(:exist?).and_call_original
        %w(
          /etc/nginx/ssl/example.com/cert.pem
          /etc/nginx/ssl/example.com/cert.key
        ).each do |file|
          allow(::File).to receive(:exist?).with(file).and_return true
        end
      end

      it 'does not overwrite the existing cert.pem link' do
        expect(chef_run).to_not create_link(
          '/etc/nginx/ssl/example.com/cert.pem'
        )
      end

      it 'does not overwrite the existing cert.key link' do
        expect(chef_run).to_not create_link(
          '/etc/nginx/ssl/example.com/cert.key'
        )
      end
    end
  end
end
