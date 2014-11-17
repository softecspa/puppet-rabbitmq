class rabbitmq::management inherits rabbitmq::params {

    exec {'rabbitmq-plugins-management':
      command     => '/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management',
      unless      => '/usr/lib/rabbitmq/bin/rabbitmq-plugins list | egrep "^\[E] rabbitmq_management"',
      environment => ['HOME=/root'],
      require     => [ Package['rabbitmq-server'], File['rabbitmq.config'] ],
    }

    file { '/usr/local/bin/rabbitmqadmin':
        ensure  => file,
        source  => 'puppet:///modules/rabbitmq/rabbitmqadmin',
        owner   => 'root',
        group   => 'root',
        mode    => 755,
    }
}
