# frozen_string_literal: true

require 'cloud_secret_env/providers/aws'

module CloudSecretEnv
  AWS_PROVIDER = :aws
  PROVIDERS = [AWS_PROVIDER].freeze
  class ProviderNotFound < StandardError; end
end
