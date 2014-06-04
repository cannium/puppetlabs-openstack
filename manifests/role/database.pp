class havana::role::allinone inherits ::havana::role {
  class { '::havana::profile::firewall': }
  class { '::havana::profile::mysql': }
}
