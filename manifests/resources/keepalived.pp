class havana::resources::keepalived{
  class{'::keepalived':}
  keepalived::vrrp::script {'haproxy-check':
    script      => 'killall -0 haproxy',
    interval    => '2',
    weight      => '10',
  }

  if ($::hostname == 'controller01') {
        $instance_state = 'MASTER'
    } else {
        $instance_state = 'BACKUP'
  }
  $vip = hiera('openstack::controller::address::virtual')
  keepalived::vrrp::instance {'openstack-vip':
    state               => $instance_state,
    priority            => '102',
    interface           => 'eth0',
    virtual_router_id   => '80',
    advert_int          =>  '3',
    virtual_ipaddress   => $vip,
    track_script        => 'haproxy-check',
  }

}
