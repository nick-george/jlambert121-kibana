# == Class: kibana::service
#
# This class manages the kibana service
#
#
class kibana::service {

  service { 'kibana':
    name     => $::kibana::service_name,
    ensure   => running,
    enable   => manual,
    require  => Package['kibana'],
    provider => $::kibana::params::service_provider,
  }
}
