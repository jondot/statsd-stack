
# please note (on v0.9.8):
# https://answers.launchpad.net/graphite/+question/152851


#
# Graphite-Web
#
package :graphite_web do

  GRAPHITE_ADMIN_DEFAULT = "https://raw.github.com/jondot/statsd-stack/master/config/stack/configs/graphite/initial_data.json"
  GRAPHITE_DASH_CONF     = "https://raw.github.com/jondot/statsd-stack/master/config/stack/configs/graphite/dashboard.conf"
  description 'Graphite Web Frontend'
  version '0.9.8'
  
  source "http://launchpad.net/graphite/1.0/#{version}/+download/graphite-web-#{version}.tar.gz" do
    builds '/tmp/graphite_web'
    custom_install 'sudo python check-dependencies.py && sudo python setup.py install'
    post :install, 'cp examples/example-graphite-vhost.conf /etc/apache2/sites-available/default'
    post :install, '/etc/init.d/apache2 reload'
    post :install, 'cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi'
    post :install, "wget -cq -O /opt/graphite/conf/dashboard.conf #{GRAPHITE_DASH_CONF}"
    post :install, "wget -cq -O initial_data.json #{GRAPHITE_ADMIN_DEFAULT}"
    post :install, 'python /opt/graphite/webapp/graphite/manage.py syncdb --noinput'
    post :install, 'chown -R www-data:www-data /opt/graphite/storage/'
    post :install, 'cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py'
    post :install, '/etc/init.d/apache2 start'

  end
  
  verify do
    has_directory '/opt/graphite/webapp/graphite'
    has_file '/etc/apache2/sites-available/default'
    has_file '/opt/graphite/conf/graphite.wsgi'
    has_file '/opt/graphite/conf/dashboard.conf'
    has_file '/opt/graphite/webapp/graphite/local_settings.py'
    has_process 'apache2'
  end
  
  requires :graphite_essentials
  requires :graphite_whisper
  requires :graphite_carbon
end


#
# Whisper
#
package :graphite_whisper do
  description 'Graphite Whisper'
  version '0.9.8'
  
  source "http://launchpad.net/graphite/1.0/#{version}/+download/whisper-#{version}.tar.gz" do
    builds '/tmp/graphite_whisper'
    custom_install 'sudo python setup.py install'
  end
  
  verify do
    has_file '/usr/local/bin/whisper-update.py'
  end
  
  requires :graphite_essentials
end


#
# Carbon
#
package :graphite_carbon do
  CARBON_INITD = "https://raw.github.com/jondot/statsd-stack/master/config/stack/configs/graphite/carbon"
  description 'Graphite Carbon'
  version '0.9.8'

  source "http://launchpad.net/graphite/1.0/#{version}/+download/carbon-#{version}.tar.gz" do
    builds '/tmp/graphite_carbon'
    custom_install 'sudo python setup.py install'
    post :install, 'cd /opt/graphite/conf' + \
                 ' && cp carbon.conf.example carbon.conf && cp storage-schemas.conf.example storage-schemas.conf'
    post :install, "wget -cq -O carbon #{CARBON_INITD} && chmod 755 carbon && mv carbon /etc/init.d/carbon"
    post :install, '/etc/init.d/carbon start'
  end

  verify do
    has_file '/opt/graphite/bin/carbon-cache.py'
    has_file '/opt/graphite/conf/storage-schemas.conf'
    has_file '/opt/graphite/conf/carbon.conf'
    has_process 'carbon-cache.py'
  end
  
  requires :graphite_essentials
end

#
# Essentials
#
package :graphite_essentials do
  apt %w(apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libapache2-mod-wsgi libaprutil1-ldap memcached python-software-properties python-twisted python-cairo-dev python-django python-ldap python-memcache python-pysqlite2 sqlite3 erlang-os-mon erlang-snmp rabbitmq-server bzr expect ssh libapache2-mod-python)
end
