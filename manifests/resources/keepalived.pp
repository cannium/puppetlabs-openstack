class havana::resources::keepalived{
  class{'::keepalived':}
  keepalived::vrrp::script {'haproxy-check':
    script      => 'killall -0 haproxy',
    interval    => '2',
    weight      => '10',
  }

  if ($::hostname == hiera('openstack::controller::hostname::01')) {
        $instance_state = 'MASTER'
        $priority_value = 105
    } else {
        $instance_state = 'BACKUP'
        $priority_value = 101
  }
  $vip = hiera('openstack::controller::address::virtual')
  keepalived::vrrp::instance {'openstack-vip':
    state               => $instance_state,
    priority            => $priority_value,
    interface           => hiera('keepalived::vrrp::interface'),
    virtual_router_id   => '80',
    advert_int          =>  '3',
    virtual_ipaddress   => $vip,
    track_script        => 'haproxy-check',
  }

}
