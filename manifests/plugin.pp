#
# == Define kibana::plugin
#
#  Defined type to manage kibana plugins
#
define kibana::plugin(
  $source,
  $ensure       = 'present',
  $install_root = $::kibana::install_path,
  $group        = $::kibana::group,
  $user         = $::kibana::user) {


  # borrowed heavily from https://github.com/elastic/puppet-elasticsearch/blob/master/manifests/plugin.pp
  $plugins_dir = "${install_root}/kibana/plugins"
  $install_cmd = "kibana-plugin install ${source}"
  $uninstall_cmd = "kibana-plugin remove ${name}"

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/sbin', "${install_root}/kibana/bin" ],
    cwd       => '/',
    user      => $user,
    tries     => 6,
    try_sleep => 10,
    timeout   => 600,
  }

#TODO, deal with upgrades!

  case $ensure {
    'installed', 'present': {
      $name_file_path = "${plugins_dir}/${name}/.name"
      exec {"install_plugin_${name}":
        command => $install_cmd,
        creates => $name_file_path,
        notify  => Service['kibana'],
        require => Package['kibana'],
      }
      file {$name_file_path:
        ensure  => file,
        content => $name,
        require => Exec["install_plugin_${name}"],
      }
    }
    'absent': {
      exec {"remove_plugin_${name}":
        command => $uninstall_cmd,
        onlyif  => "test -f ${name_file_path}",
        notify  => Service['kibana'],
      }
    }
    default: {
      fail("${ensure} is not a valid ensure command.")
    }
  }
}
