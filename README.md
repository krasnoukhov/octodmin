# Octodmin

Content management for Jekyll blogs

[![Gem Version](https://badge.fury.io/rb/octodmin.svg)](http://badge.fury.io/rb/octodmin)
[![Build Status](https://secure.travis-ci.org/krasnoukhov/octodmin.svg?branch=master)](http://travis-ci.org/krasnoukhov/octodmin?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/krasnoukhov/octodmin.svg)](https://coveralls.io/r/krasnoukhov/octodmin?branch=master)
[![Code Climate](https://img.shields.io/codeclimate/github/krasnoukhov/octodmin.svg)](https://codeclimate.com/github/krasnoukhov/octodmin)

![Screencast](http://i.imgur.com/SazYNe8.gif)

## Installation

Add this line to your Jekyll project's Gemfile:

```ruby
gem 'octodmin'
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

Octodmin can be configured using `_config.yml`. For example:

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

Valid options:

`transliterate`: use any of [babosa](https://github.com/norman/babosa#locale-sensitive-transliteration-with-support-for-many-languages)'s
languages for slug transliteration. Default is `latin`

`deploys`: if you use `octopress-deploy`, specify your deploy configuration
file to get a "Deploy" button in Octodmin.

`front_matter`: if you use custom front matter attributes, specify all
of them to extend the edit form with corresponding inputs.

Please note that Octodmin uses Octopress internally, so make sure you configure it
accordingly. For example:

```yaml
# Octopress
post_ext: markdown
post_layout: post
```

## Deployment

Since Octodmin is a simple Rack app, use your favorite Ruby application server.
For example, add `puma` to Gemfile, run `bundle`, and then `rackup`.
That's it.

When deploying Octodmin to a remote server, make sure you're able to run
`git pull`, `git push` and `octopress deploy` (if needed) successfully
in the shell of your remote user.

For basic HTTP authentication, use `Rack::Auth::Basic`.
Example for your `config.ru`:

```ruby
use Rack::Auth::Basic, "Octodmin" do |username, password|
  [username, password] == [ENV["USERNAME"], ENV["PASSWORD"]]
end
```

Just set ENV variables and you're good to go.

## Development and testing

You would need `npm` and `bower`. Run `bower install` to install asset
dependencies.

Run `rackup` to start the development server.

Run `rspec` to run tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## LICENSE

The MIT License
