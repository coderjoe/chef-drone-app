# drone specific configuration
default['drone']['version'] = '0.4'
default['drone']['port'] = '8000'
default['drone']['config']['plugin_filter'] = 'plugins/*'

# docker specific configuration
default['drone']['docker']['log_driver'] = 'syslog'

# letsencrypt
default['letsencrypt']['server'] = nil
default['letsencrypt']['contact'] = nil
