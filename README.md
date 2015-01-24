# Deploying Ruby on Rails apps on VPS
### Tools

* [chef-solo](https://docs.chef.io/chef_solo.html)
* [librarian-chef](https://github.com/applicationsonline/librarian-chef)
* [knife-solo](http://matschaffer.github.io/knife-solo/)
* [bundler](http://bundler.io/)
* [nginx](http://nginx.org/)
* [postgreSQL](http://www.postgresql.org/)
* [unicorn](https://github.com/defunkt/unicorn)
* [rbenv](https://github.com/sstephenson/rbenv)

### Getting started

##### Setting up VPS
To start you need a VPS to which you can connect through ssh.
Assume we have one and we can connect to it via:

```sh
$ ssh vps.com
```

Domain name is also required as we want to serve apps using subdomains.
Let's say we have a `vps.com` domain pointed to our VPS IP address.

VPS needs ruby, nginx, unicorn and all the staff to run RoR apps. chef-solo will help us with installation of the tools.

First we need to create a node for our VPS under the `nodes/` directory. Node will run 3 roles:
* bootstrap (setting up locale, install nodejs, rbenv).
* web (nginx)
* database (postgresql)

```ruby
# nodes/vps.com.json

{
  "run_list": [
    "role[bootstrap]",
    "role[web]",
    "role[database]"
  ]
}

```

Install gems before you start cooking VPS (`$ gem install bundler` if you don't have it yet):

```sh
$ bundle install
```

You can fetch cookbooks if you want:

```sh
$ librarian-chef install
```

To prepare&cook vps run:

```sh
knife solo bootstrap vps
```

For sure you have a great RoR app and you cannot wait any longer to show your application to the world. Let's do this!

Create a `role` for app (name can be the same as application name) which runs "rails_app" recipe:

``` ruby
# roles/example_app.json

{
  "json_class": "Chef::Role",
  "run_list": [
    "recipe[rails_app]"
  ],
  "override_attributes": {
    "app_name": "example_app",
    "authorized_keys": [
      "ssh-rsa AsadsadsecretZZZ deployer@example.com",
      "ssh-rsa AsadsadsecretZZZ me@example.com",
      "ssh-rsa BsadsadsecretZZZ contributor@example.com"
    ]
  }
}

```

Application will be available under subdomain, in this case: `http://example_app.vps.com`.
In addition to the created role still need a node to run application role:

```ruby
# nodes/example_app.vps.com.json

{
  "run_list": [
    "role[example_app]"
  ]
}
```

To cook this node you need ssh config for `example_app.vps.com` for example:

```ssh
Host example_app.vps.com
  HostName vps.com
  User example_app
  ForwardAgent yes
  IdentityFile ~/.ssh/me_rsa
```

***Cook application node as a root user***

```sh
knife solo cook root@example_app.com.vps
```

VPS is ready to go, all thats left is to deploy RoR application source code via Capistrano.

##### Rails Application

Add `capistrano` and `unicorn` gems to `Gemfile`:

```ruby
# Gemfile

gem 'capistrano', '3.2.1'
gem 'capistrano-rails'
gem 'capistrano-rbenv', '~> 2.0'

group :production do
  gem 'unicorn', '4.8.3'
end
```

Next bundle new gems:

```sh
$ bundle install
```

Create file `Capfile` into application root folder:

```ruby
# Capfile

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
```

Create `config/deploy.rb` file:

```ruby
# config/deploy.rb

lock '3.2.1'

set :application, 'example_app'
set :repo_url, 'git@github.com:username/example_app.git'

set :rbenv_custom_path, '/usr/local/rbenv'
set :rbenv_ruby, '2.1.5'

set :pty, true
set :sudo_prompt, ""
set :linked_files, %w{
  config/database.yml
  config/nginx.production.conf
  config/secrets.yml
  config/unicorn.rb
  config/unicorn_init.sh
}
set :linked_dirs, %w{ tmp log }
set :scm, :git
set :tmp_dir, "/home/#{fetch(:application)}/tmp"

namespace :deploy do
  %w{start stop restart}.each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app) do
        execute "service unicorn_#{fetch(:application)} #{command}"
      end
    end
  end
  after :finishing, :restart
end
```

and create a production deployment config file:

```ruby
# config/deploy/production.rb

set :branch, :master
set :deploy_to, '/home/example_app/production'

server 'example_app.vps.com',
  user: 'example_app',
  roles: %w{ web app db },
  ssh_options: {
    forward_agent: true
  }
```

***Also remember to add `database.yml` and `secret.yml` to `.gitignore` as those files are already on VPS
and commit all your changes.***

We're almost there... Let's deploy our app on VPS finally:

```sh
$ bundle exec cap production deploy
```

Application is live! Yay!

![alt tag](http://stream1.gifsoup.com/view7/2619424/stewie-yay-o-s.gif)

### Installation on localhost using Vagrant with VirtualBox

You need [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed:

* [DOWNLOAD Vagrant](https://www.vagrantup.com/downloads.html)
* [DOWNLOAD VirtualBox](https://www.virtualbox.org/wiki/Downloads)

In **chef-vps** directory run:
```sh
$ bundle install
```

install Vagrant plugins:

```sh
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-omnibus
```

then bring vagrant machine up and running:

```sh
$ vagrant up --provision
```
that creates the environment, provisioning is run and that's all.

Check this out :)
```sh
$ vagrant ssh
```
