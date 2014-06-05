# A basic defined resource that only checks for controller
# configuration consistency with the Hiera data
define havana::resources::controllerHA () {
  if($::hostname == 'controller01') {
      $address = hiera('openstack::controller::address::01')
  } else {
      $address = hiera('openstack::controller::address::02')
  }

  unless has_ip_address($address) {
    fail("${title} setup failed. This node is listed
    as a controller, but does not have the ip address
    ${address}.")
  }

}
