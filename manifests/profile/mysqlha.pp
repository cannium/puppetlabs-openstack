# The profile to install an OpenStack specific mysql server
class havana::profile::mysqlha {

  class { 'mysql::server':
    config_hash       => {
      'root_password' => hiera('openstack::mysql::root_password'),
      'bind_address'  => hiera('openstack::mysql::bind_address'),
    },
  }

  class { 'mysql::server::account_security': }
}
