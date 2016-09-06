require 'spec_helper'

describe 'drone_app::_nginx_docker' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'pulls the nginx image' do
      expect(chef_run).to pull_if_missing_docker_image('nginx').with(
        repo: 'nginx',
        tag: 'stable'
      )
    end

    it 'stops the existing nginx image' do
      expect(chef_run).to stop_docker_container('nginx')
    end

    it 'deletes the existing nginx image' do
      expect(chef_run).to stop_docker_container('nginx')
    end

    it 'starts the nginx image' do
      expect(chef_run).to run_docker_container('nginx').with(
        repo: 'nginx',
        tag: 'stable',
        port: ['80:80', '443:443'],
        links: ['drone:drone'],
        restart_policy: 'always'
      )
    end
  end
end
