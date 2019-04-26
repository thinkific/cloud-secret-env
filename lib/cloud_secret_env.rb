# frozen_string_literal: true

require 'pry'

require 'cloud_secret_env/providers'
require 'cloud_secret_env/config'

# CloudSecretEnv retrieves and parses secrets to set ENV
# => for the Process
module CloudSecretEnv
  class << self
    def configure
      @config ||= Config.new
      yield @config
    end

    def run
      @config ||= Config.new
      @config.validate!
      secrets = provider.fetch_secrets!
      if @config.verbose
        puts "Secrets from ids: #{@config.secret_ids}"
        pp secrets
      end
      push_env!(secrets)
    end

    private

    def provider
      case @config.provider
      when AWS_PROVIDER
        Providers::AWS.new(
          access_key: @config.access_key,
          secret_key: @config.secret_key,
          region: @config.region,
          profile_name: @config.profile_name,
          secret_ids: @config.secret_ids
        )
      end
    end

    def push_env!(secrets)
      block = if @config.override
                ->(k, v) { ENV[k] = v }
              else
                ->(k, v) { ENV[k] = v unless ENV[k] }
              end
      secrets.each(&block)
    end
  end
end
