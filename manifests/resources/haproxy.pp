class havana::resources::haproxy{
  $vip = hiera('openstack::controller::address::virtual')
  $timeout = hiera('haproxy::timeout')

  sysctl::value {'net.ipv4.ip_nonlocal_bind': value => '1'} ->
  sysctl::value {'net.ipv4.conf.all.rp_filter': value => '0'} ->
  sysctl::value {'net.ipv4.conf.default.rp_filter': value => '0'} -> 
  class { '::haproxy':
    global_options   => {
      'daemon'  => '',  # means add "daemon" in global section
    },
    defaults_options => {
      'mode'    => 'http',
      'timeout' => [
        "connect ${timeout}",
        "client ${timeout}",
        "server ${timeout}",
      ],
      'maxconn' => '10000',
    },
  }
# frontends
  haproxy::frontend {'horizon-http-vip':
      ipaddress => $vip,
      ports     => '80',
      options   => {
          'default_backend' => 'horizon-http-api',
      }
  }
  haproxy::frontend {'keystone-admin-vip':
      ipaddress => $vip,
      ports     => '35357',
      options   => {
          'default_backend' => 'keystone-admin-api',
      }
  }
  haproxy::frontend {'keystone-public-vip':
      ipaddress => $vip,
      ports     => '5000',
      options   => {
          'default_backend' => 'keystone-public-api',
      }
  }
  haproxy::frontend {'neutron-vip':
      ipaddress => $vip,
      ports     => '9696',
      options   => {
          'default_backend' => 'neutron-api',
      }
  }
  haproxy::frontend {'glance-vip':
      ipaddress => $vip,
      ports     => '9191',
      options   => {
          'default_backend' => 'glance-api',
      }
  }
  haproxy::frontend {'glance-registry-vip':
      ipaddress => $vip,
      ports     => '9292',
      options   => {
          'default_backend' => 'glance-registry-api',
      }
  }
  haproxy::frontend {'nova-ec2-vip':
      ipaddress => $vip,
      ports     => '8773',
      options   => {
          'default_backend' => 'nova-ec2-api',
      }
  }
  haproxy::frontend {'nova-novnc-vip':
      ipaddress => $vip,
      ports     => '6080',
      options   => {
          'default_backend' => 'nova-novnc-api',
      }
  }
  haproxy::frontend {'nova-compute-vip':
      ipaddress => $vip,
      ports     => '8774',
      options   => {
          'default_backend' => 'nova-compute-api',
      }
  }
  haproxy::frontend {'nova-metadata-vip':
      ipaddress => $vip,
      ports     => '8775',
      options   => {
          'default_backend' => 'nova-metadata-api',
      }
  }
  haproxy::frontend {'cinder-vip':
      ipaddress => $vip,
      ports     => '8776',
      options   => {
          'default_backend' => 'cinder-api',
      }
  }
# backends
  $hostname01 = hiera('openstack::controller::hostname::01')
  $hostname02 = hiera('openstack::controller::hostname::02')
  $address01 = hiera('openstack::controller::address::01')
  $address02 = hiera('openstack::controller::address::02')
  haproxy::backend {'horizon-http-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:80 check inter ${timeout}",
                        "${hostname02} ${address02}:80 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'keystone-admin-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:35357 check inter ${timeout}",
                        "${hostname02} ${address02}:35357 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'keystone-public-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:5000 check inter ${timeout}",
                        "${hostname02} ${address02}:5000 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'neutron-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:9696 check inter ${timeout}",
                        "${hostname02} ${address02}:9696 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'glance-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:9191 check inter ${timeout}",
                        "${hostname02} ${address02}:9191 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'glance-registry-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:9292 check inter ${timeout}",
                        "${hostname02} ${address02}:9292 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-ec2-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:8773 check inter ${timeout}",
                        "${hostname02} ${address02}:8773 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-novnc-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:6080 check inter ${timeout}",
                        "${hostname02} ${address02}:6080 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-compute-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:8774 check inter ${timeout}",
                        "${hostname02} ${address02}:8774 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-metadata-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:8775 check inter ${timeout}",
                        "${hostname02} ${address02}:8775 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'cinder-api':
      options   => {
          'server'  => ["${hostname01} ${address01}:8776 check inter ${timeout}",
                        "${hostname02} ${address02}:8776 check inter ${timeout}"],
          'balance' => 'roundrobin',
      }
  }
}
