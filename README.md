# bitnami instance manager

This app allows you to launch bitnami instances with your AWS account.

## requirements

You need to provide your AWS key and access key.
You can set up a bash variable or use `.env`

    echo AWS_ACCESS_KEY_ID=xxx >> .env
    echo AWS_SECRET_ACCESS_KEY=xxx >> .env

## Supported instances

* Wordpress

# Getting started

You need to create a new Wordpress instance.

    require 'bitnami'
    w = Bitnami::Wordpress.new

You can create a new Ec2 instance

    w.create

And check the status

    w.status
    w.status.system_status
    w.status.instance_status
    w.status.state_name
    w.status.state_code

`state_name` could be "initiating-request", "pending-acceptance", "active", "deleted", "rejected", "failed", "expired", "provisioning", "deleting"

`system_status` and `instance_status` are part of [amazon status monitoring](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring-system-instance-status-check.html)

You can browse the status of an existing instance

    require 'bitnami'
    w = Bitnami::Wordpress.new('instance_id')
    w.status

You can launch a sidekiq worker to track the status of the instance

    require 'bitnami'
    w = Bitnami::Wordpress.new
    w.create
    w.follow_status

The `WordpressStatusWorker` should check every 5 seconds.

# Run a console

I use pry to run an interactive ruby console

    pry -r bitnami -I lib/

# Run sidekiq

Sidekiq is designed to run with Rails. But you can make it run with ruby:

    bundle exec sidekiq -r ./worker.rb

# Performance

Based on my research this is the time each AWS request takes from a t1.mcrio instance

* create_instance ~ 1 second
* describe_instance ~ 0.6 seconds, sometimes 0.3 seconds

Usually, an instance takes around 5 minutes to initialize
