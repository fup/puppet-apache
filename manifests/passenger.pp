# Class: apache::passenger
#
# This class installs Phusion Passenger for Apache
#
# Parameters:
# - $passenger_package
#
# Actions:
#   - Install and configure mod_passenger package
#
# Requires:
#   Phusion Passenger Packages for your OS
#   - RPM: http://passenger.stealthymonkeys.com/
#
# Sample Usage:
#
class apache::passenger($ruby_version='',$passenger_version) inherits apache::params {

  Exec {
    path    => '/usr/lib/rvm/bin:/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if $rvm != '' {
    #  create the mod_passenger.so for the version of ruby installed by rvm
    include ruby
    include rvm

    $passenger_packages = ['curl-devel','httpd-devel','apr-devel','apr-util-devel']
    $rvm_path = $apache::params::rvm_path

    package {$passenger_packages:
      ensure => 'present',
    }

    rvm::define::gem {'passenger':
      ruby_version => $ruby_version,
      gem_version  => $passenger_version,
    }

    exec {'passenger_install':
      command => "rvm exec ${rvm_path}/gems/${ruby_version}/bin/passenger-install-apache2-module -a",
      creates => "${rvm_path}/gems/${ruby_version}/gems/passenger-${passenger_version}/ext/apache2/mod_passenger.so",
      require => [Package['curl-devel'], Package['httpd-devel'], Package['apr-devel'], Rvm::Define::Gem['passenger']],
    }

    $passenger_so   = "${rvm_path}/gems/${ruby_version}/gems/passenger-${passenger_version}/ext/apache2/mod_passenger.so"
    $passenger_ruby = "${rvm_path}/bin/${ruby_version}"
    $passenger_root = "${rvm_path}/gems/${ruby_version}/gems/passenger-${passenger_version}/"

  } else {
    include ruby

    @package { $apache::params::passenger_package:
      ensure => present,
      tag    => 'passenger-package',
    }

    $passenger_so   = "modules/mod_passenger.so"
    $passenger_ruby = '/usr/bin/ruby'
    $passenger_root = "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}"
  }

  @file { $apache::params::passenger_conf:
    ensure  => present,
    content => template('apache/passenger.conf.erb'),
    tag     => 'passenger-file',
  }

  Package<| tag == 'passenger-package' |>
  File<| tag == 'passenger-file' |>
}
