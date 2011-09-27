# Definition: apache::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - The $port to configure the host on
# - The $docroot provides the DocumentationRoot variable
# - The $ssl option is set true or false to enable SSL for this Virtual Host
# - The $template option specifies whether to use the default template or override
# - The $priority of the site
# - The $serveraliases of the site
# - Whether Phusion $passenger is used for this vhost or not (true|false)
# - Whether apache should be notified of a service $restart or not
#
# Actions:
# - Install Apache Virtual Hosts
#
# Requires:
# - The apache class
#
# Notes:
# - For usage of the Passenger module, ensure that the $docroot points to your apps public folder. 
#
# Sample Usage:
#  apache::vhost { 'site.name.fqdn':
#    priority  => '20',
#    port      => '80',
#    docroot   => '/path/to/docroot',
#    passenger => 'true',
#  }
define apache::vhost( $port, $docroot, $ssl='true', $template='apache/vhost-default.conf.erb', $priority, $serveraliases = '', $passenger = 'false', $restart = 'true' ) {

  include apache

  if $ssl == 'true' {
    include apache::ssl
  }

  if $passenger == 'true' { 
    include apache::passenger 
    if $template == 'apache/vhost-default.conf.erb' {
      $REAL_template = 'apache/vhost-passenger-default.conf.erb'
    } else { $REAL_template = $template }
  } 
  else { $REAL_template = $template }

  file {"${apache::params::vdir}/${priority}-${name}.conf":
    content => template($REAL_template),
    owner => 'root',
    group => 'root',
    mode => '777',
    require => Package['httpd'],
    before => $restart ? {
      'false' => Service['httpd'],
      default => undef,
    },
    notify => $restart ? {
      'false' => undef,
      default => Service['httpd'],
    },
  }
}
