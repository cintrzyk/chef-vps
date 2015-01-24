define :add_authorized_keys_for do
  user = params[:name]
  authorized_keys = params[:authorized_keys] || []

  directory "/home/#{user}/.ssh" do
    owner user
    group user
    mode 0755
    action :create
  end

  template "/home/#{user}/.ssh/authorized_keys" do
    action :create
    source 'authorized_keys.erb'
    mode 0755
    owner user
    group user
    cookbook 'sys_users'
    variables(
      authorized_keys: authorized_keys
    )
  end
end
