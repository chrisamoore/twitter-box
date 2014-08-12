# Stages
stage { 'config': }
stage { 'build': }

Stage['config'] -> Stage['build']

############
# General  #
############
class config {
#update the dot files
  exec { 'dotfiles':
    cwd     => "/home/vagrant",
    command => "cp -r /vagrant/puphpet/files/dot/.[a-zA-Z0-9]* /home/vagrant/ && chown -R vagrant /home/vagrant/.[a-zA-Z0-9]*",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    logoutput => true,
  }

# Glob in all of our PHP ini modules
  exec { 'ini_files':
    cwd     => "/etc/php5/mods-available/",
    command => "cp -r /vagrant/puphpet/files/php.d/* ./",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    logoutput => true,
  }

# Link
  file { '/etc/php5/cli/conf.d/30-mongo.ini':
    ensure => 'link',
    target => '/etc/php5/mods-available/mongo.ini',
    require => Exec['ini_files']
  }

  file { '/etc/php5/fpm/conf.d/30-mongo.ini':
    ensure => 'link',
    target => '/etc/php5/mods-available/mongo.ini',
    require => Exec['ini_files']
  }

  file { '/etc/php5/fpm/conf.d/30-redis.ini':
    ensure => 'link',
    target => '/etc/php5/mods-available/redis.ini',
    require => Exec['ini_files']
  }

# override the nginx.conf Explicitly
  exec { 'conf_files':
    cwd     => "/etc/nginx/conf.d/",
    command => "cp -r /vagrant/puphpet/files/custom/nginx.conf ./nginx.conf",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  }

  exec { 'conf_files_fpm':
    cwd     => "/etc/php5/fpm/pool.d/",
    command => "cp -ir /vagrant/puphpet/files/custom/www.conf ./www.conf",
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  }

#probably better served with a subscribe
  exec {'bouncer':
    command => '/etc/init.d/nginx restart && sudo /etc/init.d/php5-fpm restart && export LC_ALL="en_US.UTF-8"',
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
    logoutput => true,
    require => [Exec['ini_files'], Exec['conf_files_fpm'], Exec['conf_files'], File['/etc/php5/cli/conf.d/30-mongo.ini'], File['/etc/php5/fpm/conf.d/30-mongo.ini'], File['/etc/php5/fpm/conf.d/30-redis.ini']]
  }

  package { 'beanstalkd':
    ensure => 'latest'
  }

  service { beanstalkd:
    ensure    => 'running',
    hasrestart   => 'true',
    require => Package['beanstalkd']
  }

  exec {'setup-sass':
    command => 'gem install sass && gem install compass',
    logoutput => true,
    path => ['/usr/bin', '/bin', '/sbin'],
  }

  exec { 'composer-update':
    command     => "/usr/local/bin/composer self-update && sudo npm update -g",
    returns => [0, 1, 2, 255],
    environment => ["COMPOSER_HOME=/home/vagrant"],
    logoutput => true
  }

  exec { 'zsh-update':
    cwd => '/home/vagrant/.oh-my-zsh',
    command     => "/usr/bin/env ZSH=$ZSH /bin/sh /home/vagrant/.oh-my-zsh/tools/upgrade.sh",
    returns => [0, 1, 2, 255],
    user => 'vagrant',
    logoutput => true
  }

   vcsrepo { '/vagrant/twitter-ui':
        ensure   => present,
        provider => git,
        source   => 'git@github.com:justinwoodcock/twitter-ui.git',
    }

   vcsrepo { '/vagrant/twitter-api-blueprint':
        ensure   => present,
        provider => git,
        source   => 'git@github.com:chrisamoore/twitter-api-blueprint.git',
    }

    vcsrepo { '/vagrant/twitter-laravel':
        ensure   => present,
        provider => git,
        source   => 'git@github.com:chrisamoore/twitter-laravel.git',
    }

}

#####################
##### twitter ######
#####################
class twitter_config {

  host { 'mongo.twitter.dev':
    ip => '127.0.0.1',
  }

# MySQL twitter
  exec { "create-db-twitter":
    unless => "/usr/bin/mysql -uadmin -proot twitter",
    command => "/usr/bin/mysql -uroot -proot -e \"create database twitter; grant all on twitter.* to admin@localhost identified by 'root';\"",
    logoutput => true,
  }
}

class twitter_build {
# install the API
  exec {'composer-install-twitter':
    cwd => '/vagrant/twitter-laravel',
    command => 'composer install -vvv',
    path => ['/usr/local/bin','/usr/bin', '/bin', '/sbin'],
    environment => ["COMPOSER_HOME=/home/vagrant"],
    logoutput => true,
    returns => [0, 1, 2, 255],
    timeout => 0,
    user => 'vagrant',
  }

 # install the API
    exec {'composer-install-stampede':
        cwd => '/vagrant/twitter-laravel',
        command => 'composer install -vvv',
        path => ['/usr/local/bin','/usr/bin', '/bin', '/sbin'],
        environment => ["COMPOSER_HOME=/home/vagrant"],
        logoutput => true,
        returns => [0, 1, 2, 255],
        timeout => 0,
        user => 'vagrant',
    }

# # Load our DB fixtures
#   exec { "seed":
#     cwd => '/vagrant/twitter-laravel',
#     command => 'php artisan env:reset -f',
#     path => ['/usr/bin', '/bin', '/sbin'],
#     logoutput => true,
#     returns => [ 0, 1, 255 ],
#     require => Exec['composer-install-twitter'],
#   }

# Install UI
  exec {'npm-install':
    cwd => '/vagrant/twitter-ui',
    command => 'npm install',
    returns => [0, 1, 2, 255],
    logoutput => true,
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/node/node-v0.10.26/bin/",
  }

# Install UI
  exec {'bower-install':
    cwd => '/vagrant/twitter-ui',
    command => 'bower install --allow-root',
    returns => [0, 1, 2, 255],
    logoutput => true,
    path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/node/node-v0.10.26/bin/",
    require => Exec['npm-install']
  }
}

#####################
##### Includes ######
#####################
class { 'config':
  stage => 'config',
}

class { 'twitter_config':
  stage => 'config',
}

class { 'twitter_build':
  stage => 'build',
}

include config
include twitter_config
include twitter_build
