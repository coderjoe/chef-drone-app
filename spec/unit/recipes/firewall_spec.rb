require 'spec_helper'

describe 'drone_app::firewall' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs and enables the default firewall' do
      expect(chef_run).to install_firewall('default').with(
        enabled: true
      )
    end

    it 'allows ssh' do
      expect(chef_run).to create_firewall_rule('ssh').with(
        port: 22,
        command: :allow
      )
    end

    it 'allows http and https' do
      expect(chef_run).to create_firewall_rule('http/https').with(
        port: [80, 443],
        protocol: :tcp,
        command: :allow,
        position: 1
      )
    end
  end
end
