define rabbitmq::adduser(
#    $password,
    $vhost
)
{
    $progdir = "/root/.puppet"
    $pwfile = "${progdir}/rabbitmq_${name}_password"

    file { "${pwfile}":
        ensure      => present,
        mode        => 600,
        owner       => root,
        group       => root,
        require     => File["${progdir}"],
        before      => Exec["rabbitmq-pwgen-${name}"],
    }

    exec { "rabbitmq-pwgen-${name}":
        command     => "pwgen -cnN1 16 > ${pwfile}",
        unless      => "rabbitmqctl list_users | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"], File["${pwfile}"] ],
    }

    exec { "rabbitmq-adduser-${name}":
        command     => "rabbitmqctl add_user ${name} $(cat ${pwfile})",
        unless      => "rabbitmqctl list_users | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"], Exec["rabbitmq-pwgen-${name}"] ],
    }

    exec { "rabbitmq-map-${name}-to-${vhost}":
        command     => "rabbitmqctl add_vhost ${vhost}; rabbitmqctl set_permissions -p ${vhost} ${name} '' '' ''",
        unless      => "rabbitmqctl list_permissions -p ${vhost} | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"], Exec["rabbitmq-adduser-${name}"] ],
    }
}
