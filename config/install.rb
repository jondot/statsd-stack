$:<< File.join(File.dirname(__FILE__), 'stack')

# Require the stack base
%w(essential scm graphite statsd).each do |lib|
  require lib
end

policy :stack, :roles => :statd_server do
  requires :build_essential
  requires :scm
  requires :graphite_web
  requires :statsd
end

deployment do
  # mechanism for deployment
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
  end
 
  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

# Depend on a specific version of sprinkle 
begin
  gem 'sprinkle', ">= 0.2.3" 
rescue Gem::LoadError
  puts "sprinkle 0.2.3 required.\n Run: `sudo gem install sprinkle`"
  exit
end