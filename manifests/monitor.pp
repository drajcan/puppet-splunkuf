define splunkuf::monitor (

  $log_path,

  $splunk_user     = 'admin',
  $splunk_password = 'changeme',
  $splunk_home     = $splunkuf::splunk_home,

){

  require splunkuf

  File {
    owner => 'splunk',
    group => 'splunk',
    mode  => '0644',
  }

  exec { "${splunk_home}/bin/splunk add monitor ${log_path} -index main -sourcetype %app% -auth ${splunk_user}:${splunk_password}":
    path    => ["${splunk_home}/bin", '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    creates => "${splunk_home}/monitors/${name}",
    require => Package['splunkforwarder'],
  }->

  file { "${splunk_home}/monitors/${name}":
    ensure  => 'present',
    require => File["${splunk_home}/monitors"],
  }

}