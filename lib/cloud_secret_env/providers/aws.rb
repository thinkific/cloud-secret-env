# frozen_string_literal: true

require 'aws-sdk'

module CloudSecretEnv
  module Providers
    # CloudSecretEnv::Providers::AWS represents the cloud provider for
    # => the secrets to be consumed
    class AWS
      class SecretAuthError < StandardError; end
      class SecretNotFoundError < StandardError; end

      attr_reader(
        :access_key,
        :profile_name,
        :region,
        :secret_key
      )

      def initialize(
        access_key:,
        secret_key:,
        region:,
        profile_name:,
        secret_ids:
      )
        @access_key = access_key
        @region = region
        @profile_name = profile_name
        @secret_key = secret_key
        @secret_ids = secret_ids
        @secret_hash = {}
      end

      def fetch_secrets!
        secrets_manager = initialize_secrets_manager!
        @secret_ids.each do |secret_id|
          secret = secrets_manager.get_secret_value(secret_id: secret_id)
          @secret_hash.merge!(JSON.parse(secret.secret_string))
        end
        @secret_hash.map { |k, v| [k.upcase, v] }.to_h
      rescue Aws::Errors::MissingCredentialsError
        raise SecretAuthError, 'Secret retrieval failed, please double-check your credentials'
      rescue Aws::SecretsManager::Errors::ResourceNotFoundException
        raise SecretNotFoundError, 'Secret not found, please double-check the secret_ids field'
      end

      private

      def initialize_secrets_manager!
        options = { region: region }
        options[:profile] = profile_name if profile_name
        keys_exist = access_key && !access_key.empty? && secret_key && !secret_key.empty?
        options[:credentials] = Aws::Credentials.new(access_key, secret_key) if keys_exist
        @secrets_manager = Aws::SecretsManager::Client.new(options)
      end
    end
  end
end
