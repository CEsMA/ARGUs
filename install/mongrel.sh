#! /usr/bin/ruby1.8
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
 
if ['stop', 'restart'].include? ARGV.first
  puts "Deteniendo Mongrel"  
  `/usr/local/bin/mongrel_rails stop`
end
 
if ['start', 'restart'].include? ARGV.first
  puts "Iniciando Mongrel"
  `cd /opt/argus/ARGUs; /usr/local/bin/mongrel_rails start -d -p 80`
end
 
unless ['start', 'stop', 'restart'].include? ARGV.first
    puts "Use mongrel {start|stop|restart}"
    exit
end
