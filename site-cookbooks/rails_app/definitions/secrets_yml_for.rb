require 'securerandom'

define :secrets_yml_for do
  user = app_name = params[:name]
  path = "home/#{user}/production/shared/config/secrets.yml"

  template path do
    source 'secrets.yml.erb'
    mode 0755
    owner user
    group user
    variables secret_key_base: SecureRandom.hex(64)
    action :create_if_missing
  end
end
