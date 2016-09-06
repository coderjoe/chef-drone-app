# # encoding: utf-8

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command('letsencrypt') do
  it { should exist }
end

describe directory('/etc/letsencrypt/live/example.com') do
  it { should exist }
end

describe file('/etc/letsencrypt/live/example.com/fullchain.pem') do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0644' }
end

describe file('/etc/letsencrypt/live/example.com/privkey.pem') do
  it { should exist }
  it { should be_file }
  its('mode') { should cmp '0644' }
end

describe command('crontab -l') do
  its('stdout') { should cmp(/^\d{1,2} 1,13 \* \* \* letsencrypt renew/) }
end
