#
#
#
class naturalislogforwarder::receiver(

    $redis_password,
    $redis_servers = [],

    $elasticsearch_cluster_name,
    $elasticsearch_main_ip,

    $ssl_certificate,
    $ssl_key,

    $logstash_filter = 'filter {}',
    $logstash_template = 'logstash.es.conf.erb',
    $incomming_port = 12345,

    $package_url  = 'http://download.elastic.co/logstash/logstash/packages/debian/logstash_1.4.3-1-7e387fb_all.deb'

){

  package { 'openjdk-7-jre':
    ensure => present,
  }

  class { 'logstash':
    package_url => $package_url,
    require     => Package['openjdk-7-jre']
  }

  file {'/etc/logstash/keys':
    ensure  => directory,
    require => File['/etc/logstash']
  }

  file {'/etc/logstash/keys/star.logforwarder.naturalis.nl.crt':
    ensure  => present,
    content => $ssl_certificate,
    require => File['/etc/logstash/keys'],
    notify  => Service['logstash'],
  }

  file {'/etc/logstash/keys/star.logforwarder.naturalis.nl.key':
    ensure  => present,
    content => $ssl_key,
    require => File['/etc/logstash/keys'],
    notify  => Service['logstash'],
  }

  file {'/etc/logstash/conf.d/logstash.conf':
    ensure  => present,
    content => template("naturalislogforwarder/${logstash_template}"),
    require => File['/etc/logstash/conf.d'],
    notify  => Service['logstash'],
  }

}
