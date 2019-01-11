# JSON Partials

Easily create large JSON documents from smaller partials written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_partials'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_partials

## Usage

### Saving a JSON file.

```ruby
document = JsonPartials::Document.new(template_path)
document.render('template.rb')
document.save('template.json')
```

### Helpers

The code inside the Ruby templates is executed using `eval` with the binding of the `Document` instance. This means
all methods in `JsonPartials::Document`, private or public, are accessible to the templates. `JsonPartials::Helpers`
contains all of the methods accessible by default.

#### Custom Helpers

Best practice for adding custom helpers is to create your own module and include it inside of `JsonPartials::Helpers`:

```ruby
module MyHelpers
  def my_helper
    'Hello world!'
  end
end

JsonPartials::Helpers.include(MyHelpers)
```

#### merge(*hashes)

Merges multiple hashes together.

##### Usage

`merge(hash_a, hash_b, hash_c, ...)`

##### Example

**File: resources.rb**

```ruby
{
  resources: merge(
    render('resource_a'),
    render('resource_b')
  )
}
```

**File: resource_a.rb**

```ruby
{
  resource_a: {
    name: 'Resource A'
  }
} 
```

**File: resource_b.rb**

```ruby
{
  resource_b: {
    name: 'Resource B'
  }
}
```

**Output**

```json
{
  "resources": {
    "resource_a": {
      "name": "Resource A"
    },
    "resource_b": {
      "name": "Resource B"
    }
  }
}
```


## Development

This project is configured to use [Docker Compose](https://docs.docker.com/compose/) for development. It is set up for
[Alpine Linux](https://alpinelinux.org/), which uses [Almquist Shell](https://en.wikipedia.org/wiki/Almquist_shell)
instead of Bash, so if you need to open a shell run `docker-compose run ruby ash`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hi5dev/json_partials.
