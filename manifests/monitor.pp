define splunkuf::monitor (

  $log_path,

  $splunk_user     = 'admin',
  $splunk_password = 'changeme',
  $splunk_home     = $splunkuf::splunk_home,

){

  File {
    owner => 'splunk',
    group => 'splunk',
    mode  => '0644',
  }

  file {"${splunk_home}/monitors/":
    ensure => 'directory',
  }->

  exec { "${splunk_home}/bin/splunk add monitor ${log_path} -index main -sourcetype %app%":
    path    => ["${splunk_home}/bin", '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    creates => "${splunk_home}/monitors/${log_path}",
    require => Package['splunkforwarder'],
  }->

  file { "${splunk_home}/${log_path}":
    ensure => 'present',
  }

}