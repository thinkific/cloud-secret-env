# frozen_string_literal: true

module CloudSecretEnv
  # CloudSecretEnv::Config represents the overall configuration for the
  # => CloudSecretEnv program
  class Config
    class ConfigValidationError < StandardError; end

    attr_accessor(
      :access_key,
      :secret_key,
      :region,
      :profile_name,
      :verbose,
      :override
    )
    attr_reader :provider, :secret_ids

    def provider=(provider)
      provider = provider.to_sym
      raise ProviderNotFound, "Provider '#{provider}' not found" unless ::CloudSecretEnv::PROVIDERS.include?(provider)

      @provider = provider
    end

    def secret_ids=(secret_string)
      @secret_ids = secret_string.split(',') if secret_string
    end

    def validate! # rubocop:disable Metrics/CyclomaticComplexity
      errors = []
      errors << 'Provider cannot be blank' if provider.nil? || provider.empty?
      errors << 'Region cannot be blank' if region.nil? || region.empty?
      errors << 'Secret IDs cannot be empty' if secret_ids.nil? || secret_ids.empty?
      raise ConfigValidationError, errors.join(', ') if errors.any?
    end
  end
end
