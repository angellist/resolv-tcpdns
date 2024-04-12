# Resolv::TcpDNS

This gem is a TCP-only adaptation of `Resolv::DNS`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resolv-tcpdns'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install resolv-tcpdns

## Usage

```Ruby
# config/boot.rb

require 'resolv-replace'
require 'resolv-tcpdns'

hosts_resolver = Resolv::Hosts.new
dns_resolver = Resolv::TcpDNS.new

Resolv::DefaultResolver.replace_resolvers([hosts_resolver, dns_resolver])
```

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
