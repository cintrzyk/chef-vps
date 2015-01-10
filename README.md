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
$ ssh vps
```

VPS needs ruby, nginx, unicorn and all the staff to run RoR apps. chef-solo will help us with installation of the tools.

First we need to create a node for our VPS under the `nodes/` directory. Node will run 3 roles:
* bootstrap (setting up locale, install nodejs, rbenv).
* web (nginx)
* database (postgresql)

```ruby
# nodes/vps.json

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

##### Rails Application

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
    "app_name": "example_app"
  }
}

```

Application will be available under subdomain, in this case: `example_app.vps`.
In addition to the created role still need a node to run application role:

```ruby
# nodes/example_app.vps.json

{
  "run_list": [
    "role[example_app]"
  ]
}
```

To cook this node you need ssh config for `example_app.vps` for example:

```ssh
Host example_app.vps
  HostName vps
  User example_app
  ForwardAgent yes
```

***Unfortunately ssh key for each application user is not supported yet and you need to cook as root.***

```sh
knife solo cook root@example.vps
```

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
