user = app_name = node['app_name']

add_sys_user user
cap_dir_tree_for app_name
create_db_for app_name
nginx_site_for app_name
unicorn_for app_name
