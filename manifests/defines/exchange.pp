define rabbitmq::exchange(
  $username,
  $password,
  $vhost,
  $type
)
{
    exec { "rabbitmq-declare-exchange-${name}":
        command     => "rabbitmqadmin --username=${username} --password=${password} declare exchange --vhost=${vhost} name=${name} type=${type}",
        unless      => "rabbitmqctl list_exchanges -p ${vhost} | grep ^${name}",
        require     => [ Class["rabbitmq"], Class["rabbitmq::service"], File["/usr/local/bin/rabbitmqadmin"] ],
    }
}
