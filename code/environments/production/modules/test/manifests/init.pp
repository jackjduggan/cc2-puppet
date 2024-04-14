class test {
  # it_works.txt
  file {'/tmp/it_works.txt':
    ensure  => present,
    mode    => '0644',
    content => "It works!\n",
  }
}
