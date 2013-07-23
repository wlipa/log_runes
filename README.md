# Log Runes

The Log Runes gem adds unicode glyphs to the Rails logger output that encode the session and request id
in a way that occupies a minimum of visual space but provides very useful debugging capabilities.

For example, it is easy to grep for a single session's log output, or the log output for a complete
request, even if many requests are interleaved into the same log file.

Beyond the debugging capabilities, Runic Logs tries to keep the log file output pleasant to work
with by only occupying 10 columns of text.  It uses unicode to encode a full byte of data into each
column position in a visually clear way.
 

## Installation

Add this line to your application's Gemfile:

    gem 'log_runes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install log_runes
    

## Usage

Add the following setting to your config/application.rb file:

    config.log_tags = [ LogRunes.tag ]

Your log output will look something like the following.
    
    [★¿xÄ ϱm] Completed 200 OK in 78ms (Views: 0.7ms | ActiveRecord: 72.6ms)

The format is:

    [<encoded session id> <encoded request id>]

So to look at a user's complete session log output, do the following:

    grep "<encoded session id>" production.log

Or for a particular request:

    grep "<encoded request id>" production.log

The tag is added to the Rack environment, so tools like Airbrake will contain it in
their exception environment information.  You can therefore look at a recorded exception
and immediately produce the entire log output for that request.
  
The glyphs were chosen for legibility in OSX terminal fonts.  The standard terminal does
slow down quite a bit when there are many unicode characters; to get around this, use
the almost identical but significantly faster iTerm 2.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
