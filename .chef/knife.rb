cookbook_path    %w( cookbooks site-cookbooks )
node_path        'nodes'
role_path        'roles'
environment_path 'environments'
data_bag_path    'data_bags'
#encrypted_data_bag_secret 'data_bag_key'

knife[:berkshelf_path] = 'cookbooks'
knife[:bootstrap_version] = '11.16.4-1'
