# JSON Partials

Easily create large JSON documents from smaller partials written in Ruby.

I wrote this gem when working with the
[Amazon Serverless Application Model](https://github.com/awslabs/serverless-application-model)
after the template I was working with grew to hundreds lines of code. I needed a way to easily split the template up
to smaller, easier to manage templates, and compile them into one only when it needed to be uploaded during deployment.

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

Create a new `JsonPartials::Document` linked to the directory of your `.json.rb` templates:

```ruby
document = JsonPartials::Document.new('./json_templates')
```

Then render the template:

```ruby
document.render('template')
```

Notice that the file extensions are optional. If no extension is provided, `.json.rb` is implied, unless you disable
file extensions by setting `default_file_ext` to `false`, `nil`, or an empty string either during or after
initialization.

You can generate the JSON with `#to_json`, or save it to a file with `#save`:

```ruby
document.to_json
document.save('document.json')
```

**Additional options:**

`default_file_ext` - The default file extension to use for the templates. This defaults to `.json.rb`. When no file
extension is provided to the `#render` method, this extension is added. To disable it, set it to `false`, `nil`, or
an empty string.

`pretty` - By default the JSON is minimized. Set this to `true` to include line feeds and indentation.

### Helpers

The code inside the Ruby templates is executed using `eval` with the binding of the `Document` instance. This means
all methods in `JsonPartials::Document`, private or public, are accessible to the templates. `JsonPartials::Helpers`
contains all of the methods accessible by default.

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

## Development

This project is configured to use [Docker Compose](https://docs.docker.com/compose/) for development. It is set up for
[Alpine Linux](https://alpinelinux.org/), which uses [Almquist Shell](https://en.wikipedia.org/wiki/Almquist_shell)
instead of Bash, so if you need to open a shell run `docker-compose run ruby ash`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hi5dev/json_partials.
