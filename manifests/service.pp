# == Class: kibana::service
#
# This class manages the kibana service
#
#
class kibana::service {

  service { 'kibana':
    ensure   => running,
    enable   => true,
    require  => Package["$::kibana::package_name"],
    provider => $::kibana::params::service_provider,
  }
}
