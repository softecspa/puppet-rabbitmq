class rabbitmq::stomp inherits rabbitmq::params {
    package { 'rabbitmq-stomp':
        ensure  => present,
        notify  => Class['rabbitmq::service'],
    }
}
