user = app_name = node['app_name']

add_sys_user user
add_authorized_keys_for user do
  authorized_keys node['authorized_keys']
end
cap_dir_tree_for app_name
create_db_for app_name
nginx_site_for app_name
unicorn_for app_name
