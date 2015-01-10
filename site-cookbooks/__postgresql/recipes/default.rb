directory node['postgresql']['dir'] do
  recursive true
end

include_recipe 'postgresql::server'
