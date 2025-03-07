# general_software_edge
# Extended Workplace Services (EWS)
# Stefan Schneider

case $facts['os']['family'] {
  # .deb based systems
  'Debian': {
    # Remove Microsoft Edge stable
    exec { 'remove_microsoft_edge':
      command => 'apt-get remove -y microsoft-edge-stable',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Remove the Microsoft repo list
    file { '/etc/apt/sources.list.d/microsoft-edge.list':
      ensure => absent,
    }
  }
  # .rpm based systems
  'RedHat': {
    # Remove Microsoft Edge stable
    exec { 'remove_microsoft_edge':
      command => 'dnf remove -y microsoft-edge-stable',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Remove the Microsoft repo list
    exec { 'remove_microsoft_repo_list':
      command => "rm /etc/yum.repos.d/$(ls /etc/yum.repos.d/ | grep 'edge')",
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
  }
}
