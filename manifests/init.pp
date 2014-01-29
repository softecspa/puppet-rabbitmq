import "defines/*.pp"

class rabbitmq inherits rabbitmq::params {

    # Directory contenente le password dei servizi configurati da Puppet (TODO spostare)
    $progdir = "/root/.puppet"

    file { "${progdir}":
        ensure      => directory,
        mode        => 750,
        owner       => root,
        group       => root,
    }

    package { 'rabbitmq-server':
        ensure  => present,
        notify  => Class['rabbitmq::service'],
        before  => File['rabbitmq.config'],
    }

    file { '/etc/rabbitmq':
        ensure  => directory,
        owner   => '0',
        group   => '0',
        mode    => '0644',
        require => Package["rabbitmq-server"],
    }

    file { 'rabbitmq.config':
        ensure  => file,
        path    => '/etc/rabbitmq/rabbitmq.config',
        content => template('rabbitmq/rabbitmq.config'),
        owner   => root,
        group   => root,
        mode    => 644,
        require => File['/etc/rabbitmq'],
        notify  => Class['rabbitmq::service'],
    }

    exec { 'rabbitmq-remove-guest':
        command => 'rabbitmqctl delete_user guest',
        onlyif  => 'rabbitmqctl list_users | grep ^guest',
        require => [ Package['rabbitmq-server'], File['rabbitmq.config'] ],
    }

}
