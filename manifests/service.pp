# == Class: kibana::service
#
# This class manages the kibana service
#
#
class kibana::service {
  if $::kibana::package_provider == 'rpm' {
    service { 'kibana':
      name     => $::kibana::service_name,
      ensure   => running,
      enable   => false,
      require  => Package['kibana'],
      provider => $::kibana::params::service_provider,
    }
  }
  elsif $::kibana::package_provider == 'docker' {
  #docker run -it --name gerald --mount type=bind,source=/etc/countersight,destination=/etc/countersight,readonly --mount type=bind,source=/data/configs,destination=/data/configs --mount type=bind,source=/etc/kibana,destination=/etc/kibana,readonly --mount type=bind,source=/etc/kibana/kibana.yml,destination=/usr/share/kibana/config/kibana.yml,readonly -p 443:443 registry.countersight.co:5000/countersight_kibana:7.4.2-20191114008
    docker::run { 'kibana':
      image            => "registry.countersight.co:5000/countersight_kibana:${::kibana::version}",
      ports            => ['443:5601'],
      net              => ['countersight'],
      service_prefix   => '', #service name will end up being 'kibana'
      extra_parameters => [ '--restart=unless-stopped',
                            '--mount type=bind,source=/etc/countersight,destination=/etc/countersight,readonly',
                            '--mount type=bind,source=/data/configs,destination=/data/configs',
                            '--mount type=bind,source=/etc/kibana,destination=/etc/kibana,readonly',
                            '--mount type=bind,source=/etc/kibana/kibana.yml,destination=/usr/share/kibana/config/kibana.yml,readonly', #TODO, remove this line? We're executing Kibana with the correct commandline switches now
                            '--mount type=bind,source=/etc/countersight/kibana,destination=/usr/share/kibana/bin/kibana,readonly', #TODO, remove this line? We're executing Kibana with the correct commandline switches now
                            '--mount type=bind,source=/var/log/kibana,destination=/var/log/kibana',
                            '--mount type=bind,source=/var/run/kibana,destination=/var/run/kibana',
                            "--add-host ${::fqdn}:${facts['networking']['ip']}"]
    }
  } else {
    fail("kibana package provider must be 'docker' or 'rpm'")
  }
}
