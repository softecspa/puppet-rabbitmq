define rabbitmq::vhost(
)
{
    exec { "rabbitmq-vhost-${name}":
        command     => "rabbitmqctl add_vhost ${name}",
        unless      => "rabbitmqctl list_vhosts | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"] ],
    }

}
