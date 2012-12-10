# Class: apache::params
#
# This class manages Apache parameters
#
# Parameters:
# - The $user that Apache runs as
# - The $group that Apache runs as
# - The $apache_name is the name of the package and service on the relevant distribution
# - The $php_package is the name of the package that provided PHP
# - The $ssl_package is the name of the Apache SSL package
# - The $apache_dev is the name of the Apache development libraries package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apache::params {

  $user  = 'www-data'
  $group = 'www-data'

  case $operatingsystem {
    'centos', 'redhat', 'fedora': {
       $rvm_path = '/usr/lib/rvm'
       $apache_name = 'httpd'
       $php_package = 'php'
       $ssl_package = 'mod_ssl'
       $apache_dev  = 'httpd-devel'
       $vhost = '/etc/httpd/conf.d/vhosts.conf'
       $vdir = '/etc/httpd/sites-enabled'
       $passenger_conf = '/etc/httpd/conf.d/passenger.conf'
       $passenger_package = ['mod_passenger', 'rubygem-rake', 'rubygem-rack',
                             'rubygem-daemon_controller', 'rubygem-fastthread', 
                             'rubygem-passenger', 'rubygem-passenger-native', 
                             'rubygem-passenger-native-libs']
    }
    'ubuntu', 'debian': {
       $rvm_path = '/usr/lib/rvm'
       $apache_name = 'apache2'
       $php_package = 'libapache2-mod-php5'
       $ssl_package = 'apache-ssl'
       $apache_dev  = [ 'libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev' ]
       $vhost = '/etc/apache2/conf.d/vhosts.conf'
       $vdir = '/etc/apache2/sites-enabled/'
       $passenger_conf = "/etc/apache2/mods-available/passenger.conf"
       $passenger_package = ['libapache2-mod-passenger','passenger-doc']
    }
    default: {
       $apache_name = 'apache2'
       $php_package = 'libapache2-mod-php5'
       $ssl_package = 'apache-ssl'
       $apache_dev  = 'apache-dev'
       $vhost = '/etc/apache2/conf.d/vhosts.conf'
       $vdir = '/etc/apache2/sites-enabled/'
    }
  }
}
