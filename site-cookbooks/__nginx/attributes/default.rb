set['nginx']['dir'] = '/usr/local/nginx'
set['nginx']['source']['version'] = '1.6.2'
set['nginx']['source']['conf_path'] = "#{node['nginx']['dir']}/nginx.conf"
set['nginx']['source']['prefix'] = "/opt/nginx-#{node['nginx']['source']['version']}"
set['nginx']['source']['url'] = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
set['nginx']['source']['checksum'] = 'b5608c2959d3e7ad09b20fc8f9e5bd4bc87b3bc8ba5936a513c04ed8f1391a18'
set['nginx']['source']['sbin_path'] = "#{node['nginx']['source']['prefix']}/sbin/nginx"
set['nginx']['source']['default_configure_flags'] = %W(
  --prefix=#{node['nginx']['source']['prefix']}
  --conf-path=#{node['nginx']['dir']}/nginx.conf
  --sbin-path=#{node['nginx']['source']['sbin_path']}
)
