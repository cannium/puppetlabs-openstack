class havana::resources::migrationkey(
    $nova_home    =    '/var/lib/nova',
)
{
    include ssh::server::service
    file{ "${nova_home}/.ssh":
        ensure  => "directory",
        owner   => "nova",
        group   => "nova",
        mode    => 0700,
        require => [User["nova"], Group["nova"]],
    } ->

    file{ "${nova_home}/.ssh/config":
        ensure  => "present",
        owner   => "nova",
        group   => "nova",
        mode    => 0644,
        source  => "puppet:///modules/havana/nova_sshconfig",
        notify  => Class["ssh::server::service"],
    } ->

    file{ "${nova_home}/.ssh/id_rsa":
        ensure  => "present",
        owner   => "nova",
        group   => "nova",
        mode    => 0600,
        source  => "puppet:///modules/havana/nova_sshkey",
        notify  => Class["ssh::server::service"],
    } ->

    file{ "${nova_home}/.ssh/id_rsa.pub":
        ensure  => "present",
        owner   => "nova",
        group   => "nova",
        mode    => 0644,
        source  => "puppet:///modules/havana/nova_sshkey.pub",
        notify  => Class["ssh::server::service"],
    } ->

    file{ "${nova_home}/.ssh/authorized_keys":
        ensure  => "present",
        owner   => "nova",
        group   => "nova",
        mode    => 0600,
        source  => "puppet:///modules/havana/nova_sshkey.pub",
        notify  => Class["ssh::server::service"],
    }
}
