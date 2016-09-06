# # encoding: utf-8

# Inspec test for recipe drone_site::nginx

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

nginx_inspect = command('docker inspect --type container nginx')
container = JSON.parse(nginx_inspect.stdout).first

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should be_listening }
end

describe nginx_inspect do
  its('exit_status') { should eq 0 }
end

describe 'nginx' do
  let(:volumes) { container['HostConfig']['Binds'] }
  let(:restart_policy) { container['HostConfig']['RestartPolicy'] }

  it 'should be running' do
    expect(container['State']['Running']).to eq true
  end

  it 'should have a status of "running"' do
    expect(container['State']['Status']).to eq 'running'
  end

  ['/etc/nginx/snippets:/etc/nginx/snippets',
   '/etc/nginx/conf.d:/etc/nginx/conf.d',
   '/etc/letsencrypt:/etc/letsencrypt',
   '/srv:/srv'].each do |volume|
    it "should have the volume #{volume}" do
      expect(volumes).to include(volume)
    end
  end

  it 'should always restart' do
    expect(restart_policy['Name']).to eq 'always'
    expect(restart_policy['MaximumRetryCount']).to eq 0
  end
end

describe directory('/etc/nginx/ssl/example.com') do
  it { should exist }
end

describe file('/etc/nginx/ssl/example.com/selfsigned.pem') do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0644' }
end

describe file('/etc/nginx/ssl/example.com/selfsigned.key') do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0644' }
end

describe file('/etc/nginx/ssl/example.com/cert.pem') do
  it { should be_symlink }
  its('link_path') do
    should eq file('/etc/letsencrypt/live/example.com/fullchain.pem').link_path
  end
end

describe file('/etc/nginx/ssl/example.com/cert.key') do
  it { should be_symlink }
  its('link_path') do
    should eq file('/etc/letsencrypt/live/example.com/privkey.pem').link_path
  end
end
