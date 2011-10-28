# Class: apache::passenger
#
# This class installs Phusion Passenger for Apache
#
# Parameters:
# - $passenger_package
#
# Actions:
#   - Install Apache PHP package
#
# Requires:
#   Phusion Passenger Packages for your OS
#   - RPM: http://passenger.stealthymonkeys.com/
#
# Sample Usage:
#
class apache::passenger($rvm='') {
  include apache::params
  include ruby

  @package { $apache::params::passenger_package:
    ensure => present,
    tag    => 'passenger-package',
  }

  if $rvm != '' {
    $passenger_ruby = "/usr/lib/rvm/bin/${rvm}"
    $passenger_root = '/usr/lib/ruby/gems/1.8/gems/passenger-3.0.9'
  } else {
    $passenger_ruby = '/usr/bin/ruby'
    $passenger_root = '/usr/lib/ruby/gems/1.8/gems/passenger-3.0.9'
  }

  @file { $apache::params::passenger_conf:
    ensure  => present,
    content => template('apache/passenger.conf.erb'),
    tag     => 'passenger-file',
  }

  Package<| tag == 'passenger-package' |>
  File<| tag == 'passenger-file' |>
}
