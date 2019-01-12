# JSON Partials

Easily create large JSON documents from smaller partials written in Ruby.

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

## Development

This project is configured to use [Docker Compose](https://docs.docker.com/compose/) for development. It is set up for
[Alpine Linux](https://alpinelinux.org/), which uses [Almquist Shell](https://en.wikipedia.org/wiki/Almquist_shell)
instead of Bash, so if you need to open a shell run `docker-compose run ruby ash`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hi5dev/json_partials.
