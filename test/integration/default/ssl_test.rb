# # encoding: utf-8

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

good_protocols = %w(tls1.0 tls1.1 tls1.2)
bad_protocols = %w(ssl2 ssl3)

good_protocols.each do |p|
  describe ssl(host: 'example.com', port: 443).protocols(p) do
    it { should be_enabled }
  end
end

bad_protocols.each do |p|
  describe ssl(host: 'example.com', port: 443).protocols(p) do
    it { should_not be_enabled }
  end
end
