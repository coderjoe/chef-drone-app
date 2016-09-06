require 'spec_helper'

describe 'drone_app::letsencrypt' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.node.automatic['fqdn'] = 'example.com'
      runner.node.override['letsencrypt']['contact'] = 'fake@example.com'
      runner.node.override['letsencrypt']['staging'] = false
      runner.converge(described_recipe)
    end

    before do
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?)
        .with('/etc/letsencrypt/live/example.com')
        .and_return false
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'calls the nginx letsencrypt certs recipe' do
      expect(chef_run).to include_recipe 'drone_app::_letsencrypt_nginx'
    end

    it 'should create the letsencrypt www root' do
      expect(chef_run).to create_directory('/srv/letsencrypt/example.com').with(
        recursive: true
      )
    end

    it 'installs the letsencrypt package' do
      expect(chef_run).to install_package('letsencrypt')
    end

    it 'should configures verification via webroot' do
      expect(chef_run).to run_execute('letsencrypt_webroot').with(
        command: [
          'letsencrypt certonly',
          '--non-interactive',
          '--webroot',
          '--agree-tos',
          '-m fake@example.com',
          '-w /srv/letsencrypt/example.com',
          '-d example.com'
        ].join(' ')
      )
    end

    it 'should create letsencrypt autorenewal cron job' do
      expect(chef_run).to create_cron('letsencrypt_autorenew').with(
        command: 'letsencrypt renew',
        hour: '1,13'
      )
    end
  end

  context 'When specifying a letsencrypt server, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.automatic['fqdn'] = 'example.com'
      runner.node.override['letsencrypt']['contact'] = 'fake@example.com'
      runner.node.override['letsencrypt']['server'] = 'http://le.example.com'
      runner.converge(described_recipe)
    end

    before do
      allow(::File).to receive(:exist?).and_call_original
      allow(::File).to receive(:exist?)
        .with('/etc/letsencrypt/live/example.com')
        .and_return false
    end

    it 'should configures verification via webroot' do
      expect(chef_run).to run_execute('letsencrypt_webroot').with(
        command: [
          'letsencrypt certonly',
          '--non-interactive',
          '--server http://le.example.com',
          '--webroot',
          '--agree-tos',
          '-m fake@example.com',
          '-w /srv/letsencrypt/example.com',
          '-d example.com'
        ].join(' ')
      )
    end

    it 'should create letsencrypt autorenewal cron job' do
      expect(chef_run).to create_cron('letsencrypt_autorenew').with(
        command: 'letsencrypt renew',
        hour: '1,13'
      )
    end
  end
end
