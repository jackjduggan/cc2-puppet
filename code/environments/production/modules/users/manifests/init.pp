class users {

  # define the administrator group
  group { 'cc2admin':
    ensure => present,
    gid    => 2024,
  }

  # admin users
  user { 'jduggan':
  ensure     => present,
  uid        => '2305',
  gid        => '2024',
  groups     => ['cc2admin'],
  shell      => '/bin/bash',
  home       => '/home/jduggan',
  managehome => true,
  require    => Group['cc2admin'],
  }

  # sudo privileges for admin group
  file { '/etc/sudoers.d/admin':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0440',
  content => "%cc2admin ALL=(ALL) NOPASSWD: ALL\n",
  require => Group['cc2admin'],
  }

}
