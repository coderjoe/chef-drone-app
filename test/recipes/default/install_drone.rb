# # encoding: utf-8

# Inspec test for recipe droneio::install_drone

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe directory('/etc/drone') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/drone/dronerc') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its('mode') { should cmp '0640' }

  its('content') { should match(/REMOTE_DRIVER=gitlab/) }
  its('content') do
    should match %r{REMOTE_CONFIG=https://example\.com/fakeremoteconfig}
  end
  its('content') { should match(/DATABASE_DRIVER=sqlite3/) }
  its('content') do
    should match %r{DATABASE_CONFIG=/var/lib/drone/kitchen\.sqlite}
  end
end

describe port(8000) do
  it { should be_listening }
end
