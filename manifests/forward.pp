define splunkuf::forward (

  $forward_server = undef,
  $forward_port   = undef,

  $splunk_user     = 'admin',
  $splunk_password = 'changeme',
  $splunk_home     = $splunkuf::splunk_home,

){

  exec { "${splunk_home}/bin/splunk add forward-server ${forward_server}:${forward_port} -auth ${splunk_user}:${splunk_password}":
    path    => ["${splunk_home}/bin", '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    creates => "${splunk_home}/${forward_server}",
    require => Package['splunkforwarder'],
  }->
  file { "${splunk_home}/${forward_server}":
    ensure => 'present',
  }

}