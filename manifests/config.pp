# == Class: kibana::config
#
# This class configures kibana.  It should not be directly called.
#
#
class kibana::config (
  $version                = $::kibana::version,
  $install_path           = $::kibana::install_path,
  $port                   = $::kibana::port,
  $bind                   = $::kibana::bind,
  $ca_cert                = $::kibana::ca_cert,
  $es_url                 = $::kibana::es_url,
  $es_preserve_host       = $::kibana::es_preserve_host,
  $kibana_index           = $::kibana::kibana_index,
  $elasticsearch_username = $::kibana::elasticsearch_username,
  $elasticsearch_password = $::kibana::elasticsearch_password,
  $default_app_id         = $::kibana::default_app_id,
  $pid_file               = $::kibana::pid_file,
  $request_timeout        = $::kibana::request_timeout,
  $shard_timeout          = $::kibana::shard_timeout,
  $ping_timeout           = $::kibana::ping_timeout,
  $startup_timeout        = $::kibana::startup_timeout,
  $ssl_cert_file          = $::kibana::ssl_cert_file,
  $ssl_key_file           = $::kibana::ssl_key_file,
  $verify_ssl             = $::kibana::verify_ssl,
  $base_path              = $::kibana::base_path,
  $log_file               = $::kibana::log_file,
  $extra_config           = $::kibana::extra_config,
  $disabled_plugins       = $::kibana::disabled_plugins,
  $use_external_creds     = $::kibana::use_external_creds,
){

  if $extra_config {
    $extra_stuff = to_yaml($extra_config)
  }
  else {
    $extra_stuff = undef
  }

  $template = 'kibana-5.4.yml.erb'

  conf = '/etc/kibana/kibana.yml'
  concat { $conf:
    owner   => 'kibana',
    group   => 'kibana',
    mode    => '0440',

  concat::fragment {'kibana_config':
    target  => $conf,
    content => template("kibana/${template}"),
    order   => '01',
  }

  if $use_external_creds {
    concat::fragment {'kibana_creds':
      target  => $conf,
      source  => '/etc/kibana/creds.yaml'
      order   => '02',
    }
  }
}
