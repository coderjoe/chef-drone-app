# # encoding: utf-8

# Inspec test for recipe drone_app::docker

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command('docker') do
  it { should exist }
end

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
