# == Class: naturalislogforwarder
#
# Full description of class naturalislogforwarder here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the function of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'naturalislogforwarder':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class naturalislogforwarder (
  $certificate,
  $receiver_dns = 'logstash-receiver.naturalis.nl',
  $receiver_ip = '127.0.0.1',
  $file_input_hash = {
    'examplename' =>{
      'path'   => ['/tmp/test.log'],
      'fields' => {'tags' => 'test'}
      }
    },
  $package_url = 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder_0.4.0_amd64.deb'
  ){

  # file {'/etc/logstashforwarder':
  #   ensure => directory,
  # }

  file {'/etc/logstashforwarder/receiver.crt':
    ensure  => present,
    content => $certificate,
    require => File['/etc/logstashforwarder'],
  }

  class { 'logstashforwarder':
    servers     => [$receiver_dns],
    ssl_ca      => '/etc/logstashforwarder/receiver.crt',
    require     => File['/etc/logstashforwarder/receiver.crt'],
    package_url => $package_url,
  }

  logstashforwarder::file { $file_input_hash :}

  host { $receiver_dns :
    ip => $receiver_ip
  }

}
