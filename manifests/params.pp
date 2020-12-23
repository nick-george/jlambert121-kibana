# == Class: kibana::params
#
# This class sets default parameters
#
#
class kibana::params {
  $version                = '5.4.1'
  $base_url               = 'https://download.elasticsearch.org/kibana/kibana'
  $ca_cert                = undef
  $install_path           = '/opt'
  $tmp_dir                = '/tmp'
  $port                   = 5601
  $bind                   = '0.0.0.0'
  $es_url                 = 'http://localhost:9200'
  $es_preserve_host       = true
  $kibana_index           = '.kibana'
  $elasticsearch_username = undef
  $elasticsearch_password = undef
  $default_app_id         = 'discover'
  $request_timeout        = 30000
  $shard_timeout          = 0
  $ping_timeout           = 1500
  $startup_timeout        = 5000
  $ssl_cert_file          = undef
  $ssl_key_file           = undef
  $verify_ssl             = 'full'
  $group                  = 'kibana'
  $user                   = 'kibana'
  $base_path              = undef
  $log_file               = '/var/log/kibana/kibana.log'
  $plugins                = undef

  # These are the defaults for Kibana v7.4.2
  $kibana_start_script_args = '"${NODE}" "${DIR}/src/cli" ${@} ${EXTRA_ARGS}'
  $kibana_plugin_script_args = '"${NODE}" "${DIR}/src/cli_plugin" "$@"'

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'OracleLinux', 'SLC': {

      if versioncmp($::operatingsystemmajrelease, '7') >= 0 {
        $service_provider      = 'systemd'
        $systemd_provider_path = '/usr/lib/systemd/system'
        $run_path              = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.redhat.erb'
      }

    }

    'Debian': {

      if versioncmp($::operatingsystemmajrelease, '8') >= 0 {
        $service_provider      = 'systemd'
        $systemd_provider_path = '/lib/systemd/system'
        $run_path              = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.debian.erb'
      }
    }

    'Ubuntu': {

      if versioncmp($::operatingsystemmajrelease, '15') >= 0 {
        $service_provider      = 'systemd'
        $systemd_provider_path = '/usr/lib/systemd/system'
        $run_path              = '/run/kibana'
      } else {
        $service_provider        = 'init'
        $run_path                = '/var/run'
        $init_script_osdependend = 'kibana.legacy.service.debian.erb'
      }
    }

    'OpenSuSE': {
      $service_provider      = 'systemd'
      $systemd_provider_path = '/usr/lib/systemd/system'
      $run_path              = '/run/kibana'
    }

    'Amazon': {
      $service_provider      = 'systemd'
      $systemd_provider_path = '/usr/lib/systemd/system'
      $run_path              = '/run/kibana'
    }

    default: {
      $service_provider        = 'init'
      $run_path                = '/var/run'
      $init_script_osdependend = 'kibana.legacy.service.redhat.erb'
    }
  }

  $pid_file               = "${run_path}/kibana.pid"
}
