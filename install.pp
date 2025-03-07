# general_software_edge
# Extended Workplace Services (EWS)
# Stefan Schneider

case $facts['os']['family'] {
  # .deb based systems
  'Debian': {
    # Download and add the Microsoft GPG key
    exec { 'add_microsoft_gpg_key':
      command => 'wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -',
      unless  => 'apt-key list | grep "Microsoft"',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Add the Microsoft repo list
    file { '/etc/apt/sources.list.d/microsoft.list':
      ensure  => file,
      content => 'deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main',
      notify  => Exec['apt_update'],
    }
    # Update the package list
    exec { 'apt_update':
      command     => 'apt-get update',
      refreshonly => true,
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Install Microsoft Edge stable
    exec { 'install_microsoft_edge':
      command => 'apt-get install -y microsoft-edge-stable',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Remove downloaded config.repo
    exec { 'remove_downloaded_microsoft.list':                   # Installer creates a new microsoft-edge.list
      command => 'rm -f /etc/apt/sources.list.d/microsoft.list',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
  }
  # .rpm based systems
  'RedHat': {
    # Download and add the Microsoft GPG key
    exec { 'add_microsoft_gpg_key':
      command => 'rpm --import https://packages.microsoft.com/keys/microsoft.asc',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Add the Microsoft repo list
    exec { 'add_microsoft_repo_list':
      command => 'dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/edge/config.repo',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Install Microsoft Edge
    exec { 'install_microsoft_edge':
      command => 'dnf -y install microsoft-edge-stable',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
    # Remove downloaded config.repo
    exec { 'remove_downloaded_config_repo':                  # Installer creates a new microsoft-edge.repo
      command => 'rm -f /etc/yum.repos.d/config.repo',
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
    }
  }
  # Unsupported OS families
  default: {
    fail("Unsupported OS family: ${facts['os']['family']}")
  }
}
