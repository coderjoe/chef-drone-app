# # encoding: utf-8

# Inspec test for recipe drone_app::drone

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

require 'json'

drone_inspect = command('docker inspect --type container drone')
container = JSON.parse(drone_inspect.stdout).first

describe port(1234) do
  it { should be_listening }
end

describe file('/var/lib/drone/kitchen.sqlite') do
  it { should exist }
end

describe drone_inspect do
  its('exit_status') { should eq 0 }
end

describe 'drone' do
  let(:volumes) { container['HostConfig']['Binds'] }
  let(:restart_policy) { container['HostConfig']['RestartPolicy'] }

  it 'should be running' do
    expect(container['State']['Running']).to eq true
  end

  it 'should have a status of "running"' do
    expect(container['State']['Status']).to eq 'running'
  end

  it 'should have a volume /var/lib/drone' do
    expect(volumes).to include('/var/lib/drone:/var/lib/drone')
  end

  it 'should have the volume /var/run/docker.sock' do
    expect(volumes).to include('/var/run/docker.sock:/var/run/docker.sock')
  end

  it 'should always restart' do
    expect(restart_policy['Name']).to eq 'always'
    expect(restart_policy['MaximumRetryCount']).to eq 0
  end
end
