# Octodmin

Octodmin is a Web UI for Jekyll/Octopress blogs.

[![Gem Version](https://badge.fury.io/rb/octodmin.svg)](http://badge.fury.io/rb/octodmin)
[![Build Status](https://secure.travis-ci.org/krasnoukhov/octodmin.svg?branch=master)](http://travis-ci.org/krasnoukhov/octodmin?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/krasnoukhov/octodmin.svg)](https://coveralls.io/r/krasnoukhov/octodmin?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/krasnoukhov/octodmin.svg)](https://codeclimate.com/github/krasnoukhov/octodmin)

![Screencast](http://i.imgur.com/SazYNe8.gifv)

## Installation

Add this line to your Jekyll/Octopress project's Gemfile:

```ruby
gem 'octodmin', '~> 0.1.0'
```

And then execute:

```bash
$ bundle
```

## Usage

Octodmin assumes that there is a `_config.yml` with Jekyll
configuration.

Add `config.ru` to your project:

```ruby
require "octodmin/app"
run Octodmin::App.new(__dir__)
```

Run it as a Rack application:

```bash
$ rackup
```

## Configuration

Octodmin can be configured through `_config.yml` options.

Here is an example:

```yaml
# Octodmin settings
octodmin:
  transliterate: ukrainian
  deploys:
    - config_file: _deploy.yml
  front_matter:
    custom:
      type: "text"
```

Options:

`transliterate`: use any of [babosa](https://github.com/norman/babosa#locale-sensitive-transliteration-with-support-for-many-languages)'s
transliterations for proper slug generation. Default is `latin`

`deploys`: if you use `octopress-deploy`, specify your deploy config
file so there would be a deploy button in UI

`front_matter`: if you use custom front matter attributes, specify all
of these so post edit form would be extended with corresponding inputs

## Deployment

Since Octodmin is a simple Rack app, use your favorite Ruby
application server.
For example, add `puma` to Gemfile, run `bundle` and run `rackup`.
That's it.

When deploying Octodmin to server, make sure you're able to run
`git pull`, `git push` and `octopress deploy` (if you use that)
commands from the shell of deployment user.

## Development and testing

You have to have `npm` and `bower` installed. Run `bower install` to
install asset dependencies.

Run `rackup` to start development server.

Run `rspec` to run tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## LICENSE

The MIT License
