package :statsd do
  STATSD_HEAD   = "https://github.com/etsy/statsd.git"
  STATSD_INIT   = "https://github.com/jondot/statsd-stack/raw/master/config/stack/configs/statsd/statsd.conf"
  STATSD_CONF   = "https://github.com/jondot/statsd-stack/raw/master/config/stack/configs/statsd/local.js"
  
  description 'statsd'
  version 'HEAD'
  
  noop do
    # for some reason sprinkle needed sudo (explicitly) for git clone.
    post :install, "mkdir -p /opt/statsd/ && cd /opt && sudo git clone #{STATSD_HEAD}"
    post :install, "wget -cq -O /opt/statsd/statsd.conf #{STATSD_INIT}"
    post :install, "cp /opt/statsd/statsd.conf /etc/init/statsd.conf"
    post :install, "wget -cq -O /opt/statsd/local.js #{STATSD_CONF}"
    post :install, "sudo start statsd"
  end
  
  verify do
    has_file '/opt/statsd/stats.js'
    has_file '/opt/statsd/local.js'
    has_file '/etc/init/statsd.conf'
    has_process 'node'
  end
  
  requires :nodejs, :git
end

package :nodejs do
  description 'NodeJS'
  apt 'nodejs' do
    pre :install, 'add-apt-repository ppa:chris-lea/node.js'
    pre :install, 'apt-get update'
  end
  
  verify do
    has_executable '/usr/bin/nodejs'
  end
end

  

  