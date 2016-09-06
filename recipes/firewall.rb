firewall_rule 'ssh' do
  port 22
  command :allow
end

firewall_rule 'http/https' do
  port [80, 443]
  protocol :tcp
  position 1
  command :allow
end

firewall 'default'
