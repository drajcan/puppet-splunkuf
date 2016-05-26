# == Class: splunkuf
#
# Installs and manages the Splunk Universal Forwarder
#
# === Parameters
#
# [*targeturi*]
#   String accepts a deployment server and port
#   e.g. "deploymentserver.tld:8089"
#
# === Examples
#
#  class { 'splunkuf':
#    targeturi => 'deploymentserver.tld:8089',
#  }
#
# === Authors
#
# Paul Badcock <paul@bad.co.ck>
#
# === Copyright
#
# Copyright 2015 Paul Badcock, unless otherwise noted.
#
class splunkuf (

  $package_source,

  $splunk_home          = $::splunkuf::params::splunk_home,
  $package_provider     = $::splunkuf::params::package_provider,
  $package_ensure       = $::splunkuf::params::package_ensure,
  $tcpout_default_group = $::splunkuf::params::tcpout_default_group,
  $targeturi            = $::splunkuf::params::targeturi,
  $systemd              = $::splunkuf::params::systemd,
  $mgmthostport         = $::splunkuf::params::mgmthostport,



) inherits splunkuf::params {

  File {
    owner => 'splunk',
    group => 'splunk',
    mode  => '0644',
  }

  package { 'splunkforwarder':
    ensure   => $package_ensure,
    provider => $package_provider,
    source   => $package_source,
  }->

  file { "${splunk_home}/forwarders":
    ensure => 'directory',
  }->

  file { "${splunk_home}/monitors":
    ensure => 'directory',
  }

  case $systemd {
    true: {
      file {'/usr/lib/systemd/system/splunkforwarder.service':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/splunkuf/splunkforwarder.service',
      }
    }
    default: {
      file {'/etc/init.d/splunkforwarder':
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/splunkuf/splunkforwarder',
      }
    }
  }

  file {'/opt/splunkforwarder/etc/system/local/deploymentclient.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('splunkuf/deploymentclient.conf.erb'),
    notify  => Service['splunkforwarder'],
    require => Package['splunkforwarder'],
  }

  if $mgmthostport != undef {
    file {'/opt/splunkforwarder/etc/system/local/web.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('splunkuf/web.conf.erb'),
      notify  => Service['splunkforwarder'],
      require => Package['splunkforwarder'],
    }
  }

  service {'splunkforwarder':
    ensure => 'running',
    enable => true,
    before => [
      Define['splunkuf::forward'],
      Define['splunkuf::monitor'],
    ],
  }

}
