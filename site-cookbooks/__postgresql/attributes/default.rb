default['postgresql']['enable_pgdg_apt'] = true
default['postgresql']['version'] = '9.3'
default['postgresql']['dir'] = "/usr/local/postgresql/#{node['postgresql']['version']}/main"
default['postgresql']['client']['packages'] = ["postgresql-client-#{node['postgresql']['version']}", "libpq-dev"]
default['postgresql']['server']['packages'] = ["postgresql-#{node['postgresql']['version']}"]
default['postgresql']['contrib']['packages'] = ["postgresql-contrib-#{node['postgresql']['version']}"]
default['postgresql']['config'] = {}
default['postgresql']['config']['data_directory'] = node['postgresql']['dir']
default['postgresql']['config']['hba_file'] = "#{node['postgresql']['dir']}/pg_hba.conf"
default['postgresql']['config']['ident_file'] = "#{node['postgresql']['dir']}/pg_ident.conf"
default['postgresql']['config']['external_pid_file'] = "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
default['postgresql']['config']['listen_addresses'] = 'localhost'
default['postgresql']['config']['port'] = 5432
default['postgresql']['config']['max_connections'] = 100
default['postgresql']['config']['unix_socket_directory'] = nil
default['postgresql']['config']['unix_socket_directories'] = '/var/run/postgresql'
default['postgresql']['config']['shared_buffers'] = '24MB'
default['postgresql']['config']['log_line_prefix'] = '%t '
default['postgresql']['config']['datestyle'] = 'iso, mdy'
default['postgresql']['config']['default_text_search_config'] = 'pg_catalog.english'
default['postgresql']['config']['ssl'] = true
default['postgresql']['config']['ssl_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default['postgresql']['config']['ssl_key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
default['postgresql']['password']['postgres'] = 'md53175bce1d3201d16594cebf9d7eb3f9d' # postgres
default['postgresql']['pg_hba'] = [
  { type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'trust' },
  { type: 'local', db: 'all', user: 'all', addr: nil, method: 'ident' },
  { type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'md5' },
  { type: 'host', db: 'all', user: 'all', addr: '::1/128', method: 'md5' }
]
