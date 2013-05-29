# Installing Mongo PHP Client on Debian

We recently started using [MongoDB](http://www.mongodb.org/) for part of our new Admin project at [ShowClix](http://www.showclix.com/). Mongo provides a compiled PHP extension for their [PHP client](https://github.com/mongodb/mongo-php-driver/downloads).

Installing the extension on my local OS X dev machine was a piece of cake. Installing the extension on our Debian production servers was a pain in the ass. To prevent others trying from having to pull their hair out, I decided to throw this up here. _As a side note, this looks like this is the case for ANY compiled PECL extension on Debian_.

If you haven't installed it already, you'll need to install the php5-dev package.

    apt-get install php5-dev

Next, grab the tar ball from the downloads Mongo provides on their github account (you'll want to use the most up-to-date tarball).

    wget --no-check-certificate https://github.com/mongodb/mongo-php-driver/tarball/1.0.10
    tar -xzf mongodb-mongo-php-driver-1.0.10-0-g7ac74f1.tar.gz
    cd mongodb-mongo-php-driver-8153548/

Here's where we should be able to just run phpize and compile the extension. However, doing this may yield something along the lines of...

    $ phpize
Configuring for:
PHP Api Version: 20041225
Zend Module Api No: 20060613
Zend Extension Api No: 220060519
cp: cannot stat `libtool.m4': No such file or directory
cp: cannot stat `ltmain.sh': No such file or directory
cat: ./build/libtool.m4: No such file or directory
configure.in:3: warning: prefer named diversions configure.in:8: warning: LT_AC_PROG_SED is m4_require'd but not m4_defun'd
aclocal.m4:2619: PHP_CONFIG_NICE is expanded from...
configure.in:8: the top level
configure.in:74: error: possibly undefined macro: AC_PROG_LIBTOOL
 If this token and others are legitimate, please use m4_pattern_allow.
 See the Autoconf documentation.
configure:2275: error: possibly undefined macro: LT_AC_PROG_SED

Turns out Debian has some broken symlinks and phpize needs a few additional files. To fix this we can correct the symlinks and concatenate a few required files together. _You'll likely need to su/sudo here_.

    rm /usr/lib/php5/build/ltmain.sh
    ln -s /usr/share/libtool/config/ltmain.sh /usr/lib/php5/build/ltmain.sh

    rm /usr/lib/php5/build/libtool.m4
    ln -s /usr/share/aclocal/libtool.m4 /usr/lib/php5/build/libtool.m4

    cd /usr/share/aclocal
    cat lt~obsolete.m4 ltoptions.m4 ltsugar.m4 ltversion.m4 >> libtool.m4

This should fix our problems. Now run...

    phpize
    ./configure
    sudo make install

This should now place the mongo.so in you default extensions dir which on Debian will probably be something like...

    /usr/lib/php5/20060613+lfs/mongo.so

The last thing to do is add the extension to your php.ini file, or if you're following Debian convention, dropping a mongo.ini file with the extension in conf.d dir

    # /etc/php5/conf.d/mongo.ini
    extension=mongo.so

You can also drop a [few other directives](http://www.php.net/manual/en/mongo.configuration.php) here.

Now you should be ready to start using the Mongo client for PHP.