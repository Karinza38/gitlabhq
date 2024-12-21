# GitLab Active Context

`ActiveContext` is a gem used for interfacing with vector stores like Elasticsearch, OpenSearch and Postgres with PGVector for storing and querying vectors.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Installation

TODO

## Usage

### Configuration

Add an initializer with the following options:

1. `enabled`: `true|false`. Defaults to `false`
1. `databases`: Hash containing database configuration options
1. `logger`: Logger. Defaults to `Logger.new($stdout)`

For example:

```ruby
ActiveContext.configure do |config|
  config.enabled = true
  config.logger = ::Gitlab::Elasticsearch::Logger.build

  config.databases = {
    es1: {
      adapter: 'elasticsearch',
      prefix: 'gitlab',
      options: ::Gitlab::CurrentSettings.elasticsearch_config
    }
  }
end
```

## Contributing

TODO
