class havana::profile::qpidha {
    class{'::nova::qpid':
    	user  		=>	hiera('openstack::qpid::user'),
    	password	=>	hiera('openstack::qpid::password'),
	}
}