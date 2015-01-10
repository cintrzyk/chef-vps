define :add_sys_user do
  user params[:name] do
    supports manage_home: true
    home "/home/#{params[:name]}"
    shell '/bin/bash'
    action :create
  end
end
