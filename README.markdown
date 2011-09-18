# Statsd stack, zero to hero in under five minutes


Scripts for [Sprinkle](http://github.com/crafterm/sprinkle/ "Sprinkle"), the provisioning tool.
These scripts will set you up with a full fledged statsd machine (including daemons and dashboard).  

**Tested on Ubuntu 10.04 LTS**  


## How to get your sprinkle on:

* Get a brand spanking new slice / host (Debian or Ubuntu please, other apt-based sytems might work too)
* Install sudo if you are on Debian
* Create yourself a user (use `adduser`), add yourself to the /etc/sudoers file
* Set your slices url / ip address **in deploy.rb** (config/deploy.rb.example provided)
* Set username in config/deploy.rb if it isn't the same as your local machine (config/deploy.rb.example provided)

From your local system (from the passenger-stack directory), run:

    # Don't use -v if you don't want to see what's going on.
    sprinkle -s config/install.rb -v
    

After you've waited for everything to run, you should have a provisioned slice.

You access the graphite-web console over port 80:

    http://your-host

You can also run a test:

    $jondot@jondot-desktop:/opt/statsd$ irb
    irb(main):002:0> require 'statsd'
    => true
    irb(main):003:0> s = Statsd.new('localhost', 8125)
    => #<Statsd:0xb755ab4c @port=8125, @host="localhost">
    irb(main):011:0> s.increment('foo')
    => 7
 
You should now see the counters appear in your statsd dashboard.
Go forth and install your custom configurations, add vhosts and other VPS paraphernalia.



## Available configuration

After provisioning is complete you can take a look at the following files. Everything is
left at their defaults.  

* statsd - `/opt/statsd/local.js`
* graphite-web dashboard - `/opt/graphite/conf/dashboard.conf`
* graphite carbon storage schemas - `/opt/graphite/conf/storage-schemas.conf`
* graphite carbon `/opt/graphite/conf/carbon.conf`

To make this completely autonomous you should create an additional package/step that overwrites
these with your own (don't forget to restart appropriate services).



### Wait, what does all this install?

* Build essentials
* Git (scm)
* Graphite - `carbon`, `whisper` and `graphite-web` including `apache2`.
* Node.js
* `statsd`
* erlang (rabbitmq) - there is no python amqp support OOB (by choice), but can be added on demand easily.


## Requirements
* Ruby
* Capistrano
* Sprinkle (github.com/crafterm/sprinkle)
* An Ubuntu or Debian based VPS

## Thanks
* [Marcus Crafter](http://github.com/crafterm) and other Sprinkle contributors
* [Ben Schwartz](https://github.com/benschwarz) for this README format and git script :)


## Disclaimer

Don't run this on a system that has already been deemed "in production", its not malicious, but there is a fair chance
that you'll ass something up monumentally. You have been warned. 