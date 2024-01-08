# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_secret_env/version'

Gem::Specification.new do |spec|
  spec.name          = 'cloud_secret_env'
  spec.version       = CloudSecretEnv::VERSION
  spec.authors       = ['Kevin Blues']
  spec.license       = 'MIT'
  spec.email         = ['kevin@thinkific.com']
  spec.summary       = 'Uses external secret APIs to set env'
  spec.description   = <<-DESCRIPTION
    Configure and run on application startup to populate your program\'s env from a secrets provider
  DESCRIPTION
  spec.homepage      = 'https://github.com/thinkific/cloud-secret-env'
  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.71'
  spec.add_runtime_dependency 'aws-sdk-core', '~> 3'
  spec.add_runtime_dependency 'aws-sdk-secretsmanager', '~> 1'
end
