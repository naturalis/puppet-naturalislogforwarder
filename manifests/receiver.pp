#
#
#
class naturalislogforwarder::receiver(

    $redis_password,
    $redis_servers,

    $ssl_certificate,
    $ssl_key,

    $logstash_filter = 'filter {}',
    $incomming_port = 12345,

    $package_url  = 'http://download.elastic.co/logstash/logstash/packages/debian/logstash_1.4.3-1-7e387fb_all.deb'

){

  class { 'logstash':
    package_url => $package_url,
  }

  file {'/etc/logstash/keys/lumberjack.crt':
    ensure  => present,
    content => $ssl_certificate,
    require => Class['logstash'],
    notify  => Service['logstash'],
  }

  file {'/etc/logstash/keys/lumberjack.key':
    ensure  => present,
    content => $ssl_key,
    require => Class['logstash'],
    notify  => Service['logstash'],
  }

  file {'/etc/logstash/conf.d/logstash.conf':
    ensure  => present,
    content => template('naturalislogforwarder/logstash.conf.erb'),
    require => Class['logstash'],
    notify  => Service['logstash'],
  }

}