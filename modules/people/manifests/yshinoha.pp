class people::yshinoha {
    include virtualbox
    include chrome
    include chrome::canary
    include firefox
    include skitch
    include sublime_text_2
    include screen

    package {
        'Vagrant1.3.5':
            provider => 'pkgdmg',
            source   => 'http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/Vagrant-1.3.5.dmg'
    }
}
