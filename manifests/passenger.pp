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
class apache::passenger {

  include apache::params
  include ruby
  @package { $apache::params::passenger_package:
    ensure => present,
    tag    => 'passenger-package',
  }
  Package<| tag == 'passenger-package' |>
}
