define :unicorn_for do
  user = app_name = params[:name]
  config_path = "/home/#{user}/production/shared/config"

  template "#{config_path}/unicorn.rb" do
    source 'unicorn.rb.erb'
    mode 0775
    owner user
    group user
    action :create_if_missing
    variables app_name: app_name
    cookbook 'unicorn'
  end

  template "#{config_path}/unicorn_init.sh" do
    source 'unicorn_init.sh.erb'
    mode 0775
    owner user
    group user
    action :create_if_missing
    variables app_name: app_name
    cookbook 'unicorn'
  end

  link "/etc/init.d/unicorn_#{app_name}" do
    to "#{config_path}/unicorn_init.sh"
    only_if { File.exists?(to) }
  end
end
