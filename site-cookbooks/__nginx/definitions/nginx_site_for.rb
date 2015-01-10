define :nginx_site_for do
  user = app_name = params[:name]
  conf_path = "/home/#{user}/production/shared/config/nginx.production.conf"

  template conf_path do
    source 'nginx.conf.erb'
    mode 0775
    owner user
    group user
    action :create_if_missing
    variables app_name: app_name
    cookbook '__nginx'
  end

  link "usr/local/nginx/sites-enabled/#{app_name}" do
    to conf_path
    only_if { File.exists?(to) }
  end
end
