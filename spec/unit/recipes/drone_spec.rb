require 'spec_helper'

describe 'drone_app::drone' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the drone::default recipe' do
      expect(chef_run).to include_recipe 'drone::default'
    end

    it 'creates a drone container' do
      expect(chef_run).to run_docker_container('drone').with(tag: '0.4')
    end

    describe 'drone container' do
      let(:container) do
        chef_run.docker_container('drone')
      end

      it 'should bind to port 8000' do
        expect(container.port).to eq '8000:8000'
      end
    end
  end

  context 'When an explicit port is set , on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['drone']['port'] = '1234'
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the drone::default recipe' do
      expect(chef_run).to include_recipe 'drone::default'
    end

    it 'creates a drone container' do
      expect(chef_run).to run_docker_container('drone').with(tag: '0.4')
    end

    describe 'drone container' do
      let(:container) do
        chef_run.docker_container('drone')
      end

      it 'should bind to port 8000' do
        expect(container.port).to eq '1234:8000'
      end
    end
  end
end
