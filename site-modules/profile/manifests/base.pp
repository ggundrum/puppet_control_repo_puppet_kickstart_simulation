#the base profile should include component modules that will be on all nodes
#I am adding a comment here
class profile::base (
  String $hiera_message,
# Sensitive[String[1]] $secret,
  String[1] $secret,
) {
  case $facts['os']['release']['full'] {
    '18.04': { include profile::bionic_1804 }
    '20.04': { include profile::focal_2004 }
    default: { fail("The Ubuntu version ${facts['os']['release']['full']} ") }
  }
  include ntp
  class {'puppet_agent':
    package_version => 'auto',
  }
  class { 'motd':
    content => 'Greyson destroy and recreate'
  }
  file { '/home/ubuntu/taco.txt':
    ensure  => file,
    content => "Beef, Lettuce, Sour Cream ${secret}".node_encrypt::secret,
  }
  notify { 'nody_notify':
    message => "This is my secret ${secret}".node_encrypt::secret,
  }
  redact('secret')
}
