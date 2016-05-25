# == Class: params
#
# Default settings for Splunk Universal Forwarder
#
# === Variables
#
# [*targeturi*]
#   String accepts a deployment server and port.
#   e.g. "deploymentserver.tld:8089"
#
# === Authors
#
# Paul Badcock <paul@bad.co.ck>
#
# === Copyright
#
# Copyright 2015 Paul Badcock, unless otherwise noted.
#
class splunkuf::params {
  $targeturi            = 'spunk.tld:8089'
  $package_provider     = 'dpkg'
  $splunk_home          = '/opt/splunkforwarder'
  $package_ensure       = installed
  $tcpout_default_group = 'default_group'
  $mgmthostport         = undef

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '7': {
          $systemd = true
        }
        default: {
          $systemd = false
        }
      }
    }
    /^(Debian|Ubuntu)$/: {
      $systemd = false
    }
    default: {
      $systemd = false
    }
  }
}
