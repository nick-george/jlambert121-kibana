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
  $package_name        = $::kibana::package_name,
  $package_provider    = $::kibana::package_provider,
) {


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

  if $package_provider == 'rpm' {
    package{'kibana':
      name    => "$package_name",
      ensure  => "$version"
    }
  }

  $tag_release = 'v' + $version

  if $package_provider == 'git' {
    vcsrepo { '/usr/share/kibana':
      ensure   => latest,
      provider => git,
      source   => 'https://github.com/elastic/kibana.git',
      revision => $tag_release,
      owner    => $user,
      group    => $group
    }
  }
}
