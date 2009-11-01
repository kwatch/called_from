======
README
======

($Release: $)


About
-----

Extention Module 'called_from' provides called_from() global function
which gets filename and line number of caller.

In short:

    require 'called_from'
    filename, linenum, function = called_from(1)

is equivarent to:

    caller(1)[0] =~ /:(\d+)( in `(.*)')?/
    filename, linenum, function = $`, $1, $2

But called_from() is much faster than caller()[0].



Installation
------------

    $ sudo gem install called_from

Or

    $ tar xzf called_from_X.X.X.tar.gz
    $ cd called_from_X.X.X/
    $ ruby setup.rb config
    $ ruby setup.rb setup
    $ sudo ruby setup.rb install

Notice: called_from is implemented in both C-extention and pure Ruby.
C-extention is available on UNIX-like OS and Ruby 1.8.x.



Example
-------

    require 'called_from'
    
    ##
    ## report not only what sql is queried but also from where query() is called.
    ## (this is very convenient for development and debugging)
    ## in such examle, speed of called_from() is very important.
    ##
    def query(sql)
      filename, linenum, function = called_from()
      log.debug("#{Time.now}: #{sql} (called from #{filename}:#{linenum})")
      return connection.query(sql)
    end
    
    ##
    ## if cache data is older than template file's timestamp,
    ## refresh cache data.
    ## it is very important that called_from() is much faster than caller()[0]
    ## because speed is necessary for caching.
    ##
    def cache_helper(cache_key)
      ## check template file's timestamp
      template_filename, linenum, function = called_from()
      timestamp = File.mtime(template_filename)
      ## if cache data is newer than template's timestamp, return data
      data = @cache.get(cache_key, :timestamp=>timestamp)
      return data if data
      ## if cache data is older than template's timestamp, refresh it
      data = yield()
      @cache.set(cache_key, data)
      return data
    end



Benchmark
---------

Here is an example result of benchmark on Merb application.
This shows that called_from() is more than 30 times faster than caller()[0].


    *** n=100000
                                 user     system      total        real
    caller()[0]              7.920000   0.400000   8.320000 (  8.985343)
    caller()[0]   (*1)       8.590000   0.420000   9.010000 (  9.804065)
    called_from()            0.240000   0.010000   0.250000 (  0.257151)
    called_from() (*2)       0.250000   0.000000   0.250000 (  0.268603)


    (*1) retrieve filename and line number using pattern match (=~ /:(\d+)/)
    (*2) retrieve filename and line number



Copyright and License
---------------------

$Copyright$

$License$
