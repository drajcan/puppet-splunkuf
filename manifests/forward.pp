define splunkuf::forward (

  $forward_server = undef,
  $forward_port   = undef,

  $splunk_home = $splunkuf::splunk_home,

){

  exec { 'splunk add forward-server':
    onlyif => "${splunk_home}/bin/splunk add forward-server ${forward_server}:${forward_port}",
    path    => ["${splunk_home}/bin", '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    require => Package['splunkforwarder'],
  }

}