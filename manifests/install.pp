# == Class: kibana::install
#
# This class installs kibana.  It should not be directly called.
#
#
class kibana::install (
  $version             = $::kibana::version,
  $base_url            = $::kibana::base_url,
  $tmp_dir             = $::kibana::tmp_dir,
  $install_path        = $::kibana::install_path,
  $group               = $::kibana::group,
  $user                = $::kibana::user,
  $install_from_file   = $::kibana::install_from_file,
  $package_name        = $::kibana::package_name,
) {

  $filename = $::architecture ? {
    /(i386|x86$)/    => "kibana-${version}-linux-x86",
    /(amd64|x86_64)/ => "kibana-${version}-linux-x86_64",
  }

  $service_provider = $::kibana::params::service_provider
  $run_path         = $::kibana::params::run_path

  group { $group:
    ensure => 'present',
    system => false,
    gid    => '1339',
  }

  user { $user:
    ensure  => 'present',
    uid     => '1339',
    system  => false,
    gid     => $group,
    groups  => "countersight",
    home    => $install_path,
    require => Group[$group],
    shell   => '/sbin/nologin',
  }

  package{'kibana':
    ensure  => "$version"
  }

}
