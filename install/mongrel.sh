#!/usr/bin/env ruby
### BEGIN INIT INFO
# Provides:          ARGUs
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Inicio de ARGUs
# Description: Provee del inicio automático de ARGUs al encender la computadora
#
### END INIT INFO 
apps = [
  {:app => 'ARGUs', :environment => 'production', :user => 'root', :group => 'root', :port=>80}, 
]
 
default_port = 80
default_options = {
  :app_dir => '/opt/argus/',
  :environment => 'production',
  :user => 'mongrel',
  :group => 'mongrel'
}
 
if ['stop', 'restart'].include? ARGV.first
  apps.each do |app|
    options = default_options.merge(app)
    path = File.join options[:app_dir], options[:app]
    puts "Stopping #{path}..."
    `mongrel_rails stop -c #{path} -P log/mongrel.pid`
  end
end
 
if ['start', 'restart'].include? ARGV.first
  apps.each do |app|
    options = default_options.merge(app)
    path = File.join options[:app_dir], options[:app]
    port = options[:port] || default_port
    user = options[:user]
    group = options[:group]
    puts "Starting #{options[:app]} on #{port}..."
    `mongrel_rails start -d -p #{port} -e #{options[:environment]} -c #{path} -P log/mongrel.pid -u #{user} --group #{group}`
    default_port = port + 1
  end
end
 
unless ['start', 'stop', 'restart'].include? ARGV.first
    puts "Usage: mongrel {start|stop|restart}"
    exit
end
