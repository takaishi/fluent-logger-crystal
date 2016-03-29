# fluent-logger-crystal

[![Build Status](https://travis-ci.org/takaishi/fluent-logger-crystal.svg?branch=master)](https://travis-ci.org/takaishi/fluent-logger-crystal)

fluet-logger implementation for Crystal inspired by [fluent-logger-ruby](https://github.com/fluent/fluent-logger-ruby)

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  fluent-logger:
    github: takaishi/fluent-logger-crystal
```


## Usage

### Simple

```crystal
require "fluent-logger"

log = Fluent::Logger::FluentLogger.new(nil, host: "localhost", port: 24224)
unless log.post("mqyapp.access", {agent: "foo"})
  p log.last_error # You can get last error object via last_error method
end

# output: myapp.access {"agent":"foo"}
```

### Singleton

```crystal
require "fluent-logger"

Fluent::Logger::FluentLogger.open(nil, host: "localhost", port: 24224)
Fluent::Logger.post("myapp.access", {agent: "foo"})

# output: myapp.access {"agent":"foo"}
```

### Tag Prefix

```crystal
require "fluent-logger"

log = Fluent::Logger::FluentLogger.new("myapp", host: "localhost", port: 24224)
log.post("access", {agent: "foo"})

# output: myapp.access {"agent":"foo"}
```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/takaishi/fluent-logger-crystal/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [takaishi](https://github.com/takaishi) Ryo Takaishi - creator, maintainer
