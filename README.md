Helpdesk [![Code Climate](https://codeclimate.com/repos/55154f17e30ba03d3f0001be/badges/c165a8b65f25d24d08a2/gpa.svg)](https://codeclimate.com/repos/55154f17e30ba03d3f0001be/feed)
========

###Dependencies

You may need to install the `postgresql-contrib` package to enable extensions.
On Ubuntu linux, the command to do so is the following:

```bash
sudo apt-get install postgresql-contrib-9.4
```

###Installing:

  -bundle install

  -rename .sample.env to .env

  -set your secret_key

  -rake db:setup

###Running

To spin up the development server, follow the standard procedure.

```
rails server
```

The default login/password is `admin@tracersoft.com.br/supertracer10`

Guidelines
----------

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)# project-help
