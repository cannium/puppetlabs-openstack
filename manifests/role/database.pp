class havana::role::database inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::mysql': }
}
