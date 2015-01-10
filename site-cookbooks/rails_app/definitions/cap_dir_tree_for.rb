define :cap_dir_tree_for do
  user = app_name = params[:name]

  %W(
    /home/#{user}/production
    /home/#{user}/production/shared
    /home/#{user}/production/shared/config
    /home/#{user}/production/shared/log
    /home/#{user}/production/shared/tmp
    /home/#{user}/production/shared/tmp/pids
  ).each do |path|
    directory path do
      owner user
      group user
      mode 0755
      action :create
    end
  end

  secrets_yml_for app_name
end
