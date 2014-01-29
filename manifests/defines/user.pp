define rabbitmq::user(
    $password=false,
    $update=false,
    $permissions=false,
    $administrator=false,
    $vhost
)
{
    # TODO: implementare update=true
    $real_permissions = $permissions ? {
      false => '".*" ".*" ".*"',
      default => $permissions,
    }

    $real_password = $password ? { 
      false => 'rabbit',
      default => $password,
    } 

    exec { "rabbitmq-user-${name}":
        command     => "rabbitmqctl add_user ${name} ${real_password}",
        unless      => "rabbitmqctl list_users | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"] ],
    }

    exec { "rabbitmq-permissions-${name}-to-${vhost}":
        command     => "rabbitmqctl set_permissions -p ${vhost} ${name} ${real_permissions}",
        unless      => "rabbitmqctl list_permissions -p ${vhost} | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"], Exec["rabbitmq-user-${name}"] ],
    }

    if $administrator {
        exec { "rabbitmq-set-administrator-${name}":
            command     => "rabbitmqctl set_user_tags ${name} administrator",
            unless      => "rabbitmqctl list_users | grep ^${name} | grep administrator",
            require     => [ Class["rabbitmq"], Class["rabbitmq::service"], Exec["rabbitmq-user-${name}"] ],
        }
    }
}
