class people::yshinoha {
    include python
    include virtualbox
    include chrome
    include chrome::canary
    include firefox
    include skitch
    include sublime_text_2
    include screen
    include evernote

    # install with homebrew
    package {
      [
        'tree',
        'wget',
        'fontforge'
      ]:;
    }

    # install mac applications
    package {
        'Kobito':
          source   => 'http://kobito.qiita.com/download/Kobito_v1.2.0.zip',
          provider => 'compressed_app';
        'Vagrant1.3.5':
          provider => 'pkgdmg',
          source   => 'http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/Vagrant-1.3.5.dmg';
        'GoogleJapaneseInput':
          source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
          provider => 'pkgdmg';
        'AdobeCreativeCloud':
          source => "https://ccmdls.adobe.com/AdobeProducts/KCCC/1/osx10/CreativeCloudInstaller.dmg",
          provider => 'pkgdmg';
    }

    # settings for dotfiles
    $home     = "/Users/${::boxen_user}"
    $dotfiles = "${home}/.dotfiles"

    file { $home:
      ensure  => directory
    }
    repository {
      $dotfiles:
        source   => 'git@github.com:yshinoha/.dotfiles.git',
        require => File[$home];
    }

    # settings for vim
    include vim

    # Example of how you can manage your .vimrc
    file { "${vim::vimrc}":
      target  => "/Users/${::boxen_user}/.dotfiles/.vimrc",
      require => Repository[$dotfiles]
    }

    $vim      = "${home}/.vim"
    $neobundle   = "${vim}/bundle"
    $powerline   = "${neobundle}/vim-powerline"
    $fontpatcherdir = "${neobundle}/vim-powerline/fontpatcher"
    $fontpatcher = "${fontpatcherdir}/fontpatcher"
    #$fontpatcher = "${fontpatcherdir}"
    $inconsolata = "${fontpatcherdir}/Inconsolata.otf"
    $wgetInconsolata = "wget http://levien.com/type/myfonts/Inconsolata.otf"
    $vimPluginInstall = "yes | vim -c 'q'"


#    file { $vim:
#      ensure => "directory",
    #}

    vim::bundle { [
      'scrooloose/syntastic',
      'sjl/gundo.vim'
    ]: }

    repository { $neobundle:
      source => "git@github.com:Shougo/neobundle.vim",
      path => "${neobundle}/neobundle.vim"

      #require => File[$vim]
    }
    repository { $powerline:
      source => "git@github.com:Lokaltog/vim-powerline.git"#,
      #require => File[$vim]
    }
    exec { $vimPluginInstall:
      creates => "${fontpatcher}",
      require => Repository[$neobundle],
    }

    # cwd 作業ディレクトリ
    exec { $wgetInconsolata:
      cwd => $fontpatcherdir,
      creates => "$inconsolata",
      require => Package['wget'],
    }
    exec { "fontforge -script ${fontpatcher} ${inconsolata}":
      cwd => $fontpatcherdir,
      require => [ Exec[$vimPluginInstall], Exec[$wgetInconsolata], Package['fontforge'] ],
    }

    # Or, simply,
    #file { "${vim::vimrc}": ensure => exists }
}
