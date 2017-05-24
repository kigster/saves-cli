# Saves CLI

Saves CLI client, able to create, fetch, delete, find saves across sharded dataset.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'saves-cli', git: 'git@github.com:wanelo/saves-cli.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ cd ~/workspace
    $ git clone git@github.com:wanelo/saves-cli.git
    $ cd saves-cli && bundle && bundle exec rake install

## Usage

```bash
❯ saves-cli --help
Usage: saves-cli [options] [command [options]]

    -v, --[no-]verbose               run verbosely
    -h, --help                       prints this help

Available Commands:

      create : a new save using the provided data
       fetch : an existing save by its identifier
```

### Subcommands

#### Create

```bash
❯ saves-cli create --help
Usage: saves-cli create [options]
    -b, --base-url URL               saves service base URL
                                     defaults to http://localhost:3001
    -u, --user USER                  user ID
    -p, --product PRODUCT            product ID
    -c, --collection COLLECTION      collection ID
    -h, --help                       prints this help
```

#### Fetch

```bash
❯ saves-cli fetch --help
Usage: saves-cli fetch [options]
    -b, --base-url URL               saves service base URL
                                     defaults to http://localhost:3001
    -s, --save SAVE                  three-part save, eg. 'f3-32r-e3'
    -h, --help                       prints this help
```    

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/wanelo/saves-cli](https://github.com/wanelo/saves-cli)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

