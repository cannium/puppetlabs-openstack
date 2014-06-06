class havana::resources::haproxy{
  $vip = hiera('openstack::controller::address::virtual')

  sysctl::value {'net.ipv4.ip_forward': value => '1'} ->
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
        'connect 10s',
        'client 10s',
        'server 10s',
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
  $controller01 = hiera('openstack::controller::address::01')
  $controller02 = hiera('openstack::controller::address::02')
  haproxy::backend {'horizon-http-api':
      options   => {
          'server'  => ["controller01 ${controller01}:80 check inter 10s",
                        "controller02 ${controller02}:80 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'keystone-admin-api':
      options   => {
          'server'  => ["controller01 ${controller01}:35357 check inter 10s",
                        "controller02 ${controller02}:35357 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'keystone-public-api':
      options   => {
          'server'  => ["controller01 ${controller01}:5000 check inter 10s",
                        "controller02 ${controller02}:5000 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'neutron-api':
      options   => {
          'server'  => ["controller01 ${controller01}:9696 check inter 10s",
                        "controller02 ${controller02}:9696 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'glance-api':
      options   => {
          'server'  => ["controller01 ${controller01}:9191 check inter 10s",
                        "controller02 ${controller02}:9191 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'glance-registry-api':
      options   => {
          'server'  => ["controller01 ${controller01}:9292 check inter 10s",
                        "controller02 ${controller02}:9292 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-ec2-api':
      options   => {
          'server'  => ["controller01 ${controller01}:8773 check inter 10s",
                        "controller02 ${controller02}:8773 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-novnc-api':
      options   => {
          'server'  => ["controller01 ${controller01}:6080 check inter 10s",
                        "controller02 ${controller02}:6080 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-compute-api':
      options   => {
          'server'  => ["controller01 ${controller01}:8774 check inter 10s",
                        "controller02 ${controller02}:8774 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'nova-metadata-api':
      options   => {
          'server'  => ["controller01 ${controller01}:8775 check inter 10s",
                        "controller02 ${controller02}:8775 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
  haproxy::backend {'cinder-api':
      options   => {
          'server'  => ["controller01 ${controller01}:8776 check inter 10s",
                        "controller02 ${controller02}:8776 check inter 10s"],
          'balance' => 'roundrobin',
      }
  }
}
