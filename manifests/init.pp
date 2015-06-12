# Atze de Vries <atze.devries@naturalis.nl>
#
# === Copyright
#
# Copyright 2015 Naturalis, unless otherwise noted.
#
class naturalislogforwarder (

  $certificate,

  $hosts = {
    'test1.example.com' => {
      'ip' => '127.0.0.1'
    },
    'test2.example.com' => {
      'ip' => '127.0.0.1'
    }
  },

  $lumberjack_hosts = ['test1.example.com:12345','test2.example.com:4567'],

  $file_input_hash = {
    'examplename' =>{
      'paths'   => ['/tmp/test.log'],
      'fields' => {'tags' => 'test'}
      }
    },

  $package_url = 'https://download.elastic.co/logstash-forwarder/binaries/logstash-forwarder_0.4.0_amd64.deb'

){


  file {'/etc/logstashforwarder/receiver.crt':
    ensure  => present,
    content => $certificate,
    require => File['/etc/logstashforwarder'],
  }

  class { 'logstashforwarder':
    servers     => $lumberjack_hosts,
    ssl_ca      => '/etc/logstashforwarder/receiver.crt',
    package_url => $package_url,
  }

  create_resources(host, $hosts, {})
  create_resources(logstashforwarder::file, $file_input_hash,{})
}
