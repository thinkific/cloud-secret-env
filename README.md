# CloudSecretEnv

CloudSecretEnv handles populating your ruby program's environment via cloud secrets providers. All you have to do is configure it for your desired provider (AWS SecretsManager, Hashicorp Vault, etc.) and then call `run` when your application starts. This library has no opinions as to how you populate your configuration, whether you use environment variables, locally loaded files, or just hardcoded arguments.

Current supported providers:
- [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Required:
- Ruby 2.0+
- Rubocop

```ruby
gem install rubocop
```

Optional:
- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)


### Installing

A step by step series of examples that tell you how to get a development env running

Bundler install
```bash
gem 'cloud_secret_env'
```

In your program
```ruby
require 'cloud_secret_env'

CloudSecretEnv.configure do |cse|
  cse.provider = 'aws'
  cse.region = 'us-east-1'
  cse.secret_ids = 'secret1,secret2'
end

CloudSecretEnv.run
```

## Running the tests

Running tests depends on whether you're using Docker or not.

### Local Dev

Run tests
```bash
bundle exec rake
```

### Docker

Start container and exec into it
```bash
docker-compose up -d && docker-compose exec ruby bash
```

Run tests
```bash
bundle exec rake
```

### Unit Tests

Unit tests are implemented using [RSpec](https://rspec.info/) and we do our best to follow [Better Specs](http://www.betterspecs.org/)

```ruby
RSpec.describe CloudSecretEnv::Config do
  # use efficient variable assignments
  let(:config) { described_class.new }
  ...
  # describe the method being tested
  describe '#validate!' do
    subject { config.validate! }

    # use contexts for representing state
    context 'provider is blank' do
      # and it blocks for expectations
      it 'fails validation' do
        # use described_class when referring to parent class
        expect { subject }.to raise_error described_class::ConfigValidationError
      end
      ...
    end

    context 'region is blank' do
      it 'fails validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end
      ...
    end
  end
end
```

### Code style tests

This project is linted using Rubocop. It's run in SemaphoreCI and can also be run in your editor of choice. 

Links for popular editors:
- [VS Code](https://github.com/misogi/vscode-ruby-rubocop)
- [Atom](https://atom.io/packages/linter-rubocop)
- [Sublime Text](https://github.com/pderichs/sublime_rubocop)

## Deployment

Make sure you have the required credentials for whichever cloud provider you're using. 

As an example with AWS Secrets Manager, you'll need one of:
- ENV credentials 'AWS_ACCESS_KEY_ID' and 'AWS_SECRET_ACCESS_KEY'
- Profile + credentials files in `$HOME/.aws/`
- Instance profiles attached to resources in AWS

### Timing

As a note on timing, be careful where you call `CloudSecretEnv#run`. By default, it will only set environment variables that are already empty, but by setting `override` to true in the configure block, you can force CloudSecretEnv to overwrite existing variables.

The best way to test this is by setting `verbose` to true in the configure block, which will display all the credentials to the terminal after setting them. Don't do this in production of course, but it can be useful for testing your development and testing environments.

For example, let's set an env var first without `override`. This means that `SERVICE_A_ACCESS_ENABLED` will remain set to 'false'.
```ruby
ENV['SERVICE_A_ACCESS_ENABLED'] = 'false'
CloudSecretEnv.configure do |cse|
  cse.provider = 'aws'
  cse.region = 'us-east-1'
  cse.secret_ids = 'secret1,secret2'
  cse.verbose = true
  # override is false by default
end
CloudSecretEnv.run

# example output
# {"SERVICE_A_ACCESS_ENABLED"=>"false",
#  "SERVICE_B_ACCESS_ENABLED"=>"true",
#  "SERVICE_C_ACCESS_ENABLED"=>"true",
#  "API_KEY"=>"aaaaaabbbbbbbbbb",
#  "DOMAIN"=>"cdcdcdcdcdcdcdcd",
# ...}
```

But if you set `override` to true, `SERVICE_A_ACCESS_ENABLED` is set to 'true'.
```ruby
ENV['SERVICE_A_ACCESS_ENABLED'] = 'false'
CloudSecretEnv.configure do |cse|
  cse.provider = 'aws'
  cse.region = 'us-east-1'
  cse.secret_ids = 'secret1,secret2'
  cse.verbose = true
  cse.override = true
end
CloudSecretEnv.run

# example output
# {"SERVICE_A_ACCESS_ENABLED"=>"true",
#  "SERVICE_B_ACCESS_ENABLED"=>"true",
#  "SERVICE_C_ACCESS_ENABLED"=>"true",
#  "API_KEY"=>"aaaaaabbbbbbbbbb",
#  "DOMAIN"=>"cdcdcdcdcdcdcdcd",
# ...}
```

## Built With

* [AWS SDK](https://aws.amazon.com/sdk-for-ruby/) - AWS SDK for Ruby (V2)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Kevin Blues** - *Initial work* - [kbluescode](https://github.com/kbluescode) on behalf of [Thinkific](https://github.com/thinkific)

See also the list of [contributors](https://github.com/thinkific/cloud-secret-env/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
