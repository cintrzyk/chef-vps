require 'securerandom'

define :create_db_for do
  user = app_name = params[:name]
  database_yml_path = "home/#{user}/production/shared/config/database.yml"
  db_name = "#{app_name}_production"
  db_password = SecureRandom.hex(8)

  execute 'create db with database.yml config' do
    not_if { File.exists? database_yml_path }
    sql_commands = [
      %(CREATE ROLE #{user} LOGIN PASSWORD '#{db_password}'),
      %(CREATE DATABASE #{db_name} OWNER #{user} ENCODING 'UTF8')
    ]

    sql = sql_commands.join('; ')
    command %(echo "#{sql}" | sudo -u postgres psql; true)
  end

  template database_yml_path do
    action :create_if_missing
    source 'database.yml.erb'
    mode 0755
    owner user
    group user
    variables(
      username: user,
      db_name: db_name,
      db_password: db_password
    )
  end
end
