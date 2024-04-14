class packages (
  $server_ip = '123.45.67.89',
) {

  # nginx
  package { 'nginx':
    ensure => latest,
  }
  service { 'nginx':
    ensure => stopped,
    enable => false,
  }

  # docker
  package { 'docker.io':
    ensure => installed,
  }

  service { 'docker':
    ensure    => running,
    enable    => true,
    require   => Package['docker.io'],
  }

  # haproxy
  package { 'haproxy':
    ensure => installed,
  }

  file { '/etc/haproxy/haproxy.cfg':
    ensure  => file,
    mode    => '0644',
    content => template('/etc/puppet/code/environments/production/modules/packages/templates/haproxy.cfg.erb'),
    require => Package['haproxy'],
    notify  => Service['haproxy'],
  }

  service { 'haproxy':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/haproxy/haproxy.cfg'],
  }

  # apache2
  $apache_package = $facts['os']['family'] ? {
    'RedHat'  => 'httpd',
    'Debian'  => 'apache2',
    default   => 'apache2',
  }

  $apache_service = $apache_package

  package { $apache_package:
    ensure => installed,
  }

  service { $apache_service:
    ensure    => running,
    enable    => true,
    require   => Package[$apache_package],
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    mode    => '0644',
    content => template('/etc/puppet/code/environments/production/modules/packages/templates/index.html.erb'),
    notify  => Service[$apache_service],
    require => Package[$apache_package],
  }

  # git (from puppetlabs-git)
  class { 'git':
    package_ensure => latest,
  }

  git::config { 'user.name':
    value => 'jackjduggan',
  }

  git::config { 'user.email':
    value => '20094010@mail.wit.ie',
  }
}
