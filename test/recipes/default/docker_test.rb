# # encoding: utf-8

# Inspec test for recipe droneio::docker

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe package('docker-engine') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe group('docker') do
  it { should exist }
end
