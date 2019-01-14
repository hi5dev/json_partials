# JSON Partials

Easily create complex JSON documents using Ruby templates.

I wrote this gem when working with the
[AWS Serverless Application Model](https://github.com/awslabs/serverless-application-model)
after the template I was working with grew to hundreds lines of code. I needed a way to easily split the template up
to smaller, easier to manage templates, and compile them into one only when it needed to be uploaded during deployment.

With this gem, you can create a folder that contains Ruby files that will be compiled into a single JSON document. It
includes a helper for building a Rake task to make it easy to build from the command line.

For example, let's say you're building an AWS SAM template with several resources. You could put each resource in a
separate file, and reference them in the main template, like this:

```ruby
{
  AWSTemplateFormatVersion: '2010-09-09',
  Transform: 'AWS::Serverless-2016-10-31',

  Resources: merge(
    render(:resources, :lambda_function),
    render(:resources, :api_gateway),
    render(:resources, :permissions),
    render(:resources, :dynamodb_table)
  )
}
```

The template contains Ruby code with the last expression as the output that gets added to the JSON document when it's
rendered.

Then you can set up a Rake task for building the JSON by adding this to your Rakefile:

```ruby
require 'json_partials/rake_task'

JsonPartials::RakeTask.new(:build) do |t|
  t.output_file = 'template.json'
  t.template_name = 'aws_template'
  t.template_path = 'config/templates'
end
```

Then you just have to run `rake build` to create the template.

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

Create a directory for your templates anywhere in your project.

Templates should be named using the dual file extension `.json.rb`. This is the default extension used when you don't
provide one to the `render` method inside your templates. You can change it if you need to when you set up the Rake
task, or in your code if you're building the documents manually.

The last expression in your template is what gets rendered to the document when you call `render`.

You can split Hashes into multiple templates using the `merge` helper method. In the above example, each resource
template outputs a Hash, like this:

```ruby
# File: resources/lambda_function.json.rb
{
  LambdaFunction: {
    Type: 'AWS::Serverless::Function',
    # ...
  }
}
```

```ruby
# File: resources/api_gateway.json.rb
{
  APIGateway: {
    Type: 'AWS::Serverless::Api',
    # ...
  }
} 
```

Which get combined together into a single Hash like this:

```ruby
{
  LambdaFunction: {
    Type: 'AWS::Serverless::Function',
    # ...
  },
  APIGateway: {
    Type: 'AWS::Serverless::Api',
    # ...
  }
} 
```

### Using with Rake

```ruby
require 'json_partials/rake_task'

# The name of the task is the only argument the initializer requires. You can
# also pass a Hash if you prefer instead of using a block to configure the
# task.
JsonPartials::RakeTask.new(:task_name) do |t|
  ## Required configuration.

  # Full path to the JSON output file.
  t.output_file = File.expand_path('template.json', __dir__)

  # Which template to render when calling the task.
  t.template_name = 'aws_template'

  # Full path to the directory with the .json.rb templates.
  t.template_path = File.expand_path('config/templates', __dir__)

  ## Optional configuration - values below are the defaults.

  # When +true+ the JSON output will contain line feeds and indentation.
  t.pretty = false

  # Description of the Rake task - useful when creating multiple tasks.
  t.description = 'Builds the JSON template'

  # The file extension used when one is not provided to the #render method.
  t.default_file_ext = '.json.rb'

  ## Advanced configuration.

  # You can also add a module with custom helper methods. This only works with
  # block configuration.
  t.extend(CustomHelpers)
end
```

### Using without Rake

```ruby
require 'json_partials'

# Full path to the directory with the templates.
template_path = File.expand_path('config/templates', __dir__)

# Full path to save the JSON file.
output_file = File.expand_path('template.json', __dir__)

# The template path is the only required argument. You can also provide
# one of these optional arguments:
#
# default_file_ext - Defaults to '.json.rb'
# pretty - Defaults to false.
document = JsonPartials::Document.new(template_path)

# Render the entry-point template.
document.render('template_name')

# Create the JSON file.
document.save(output_file)
```

## Development

This project is configured to use [Docker Compose](https://docs.docker.com/compose/) for development. It is set up for
[Alpine Linux](https://alpinelinux.org/), which uses [Almquist Shell](https://en.wikipedia.org/wiki/Almquist_shell)
instead of Bash, so if you need to open a shell run `docker-compose run ruby ash`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hi5dev/json_partials.
