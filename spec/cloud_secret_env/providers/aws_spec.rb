# frozen_string_literal: true

RSpec.describe CloudSecretEnv::Providers::AWS do
  describe '#fetch_secrets!' do
    let!(:provider) do
      CloudSecretEnv::Providers::AWS.new(
        access_key: nil,
        region: nil,
        profile_name: nil,
        secret_key: nil,
        secret_ids: ['derp']
      )
    end
    let(:secrets_manager) { double(:secrets_manager) }
    let(:secret) { double(:secret) }

    subject { provider.fetch_secrets! }

    before do
      allow_any_instance_of(described_class)
        .to receive(:initialize_secrets_manager!)
        .and_return(secrets_manager)
    end

    context 'Missing credentials error raised' do
      before do
        allow(secrets_manager)
          .to receive(:get_secret_value)
          .and_raise(Aws::Errors::MissingCredentialsError)
      end

      it 'should raise SecretAuthError' do
        expect { subject }.to raise_error described_class::SecretAuthError
      end
    end

    context 'Resource not found exception raised' do
      before do
        allow(secrets_manager)
          .to receive(:get_secret_value)
          .and_raise(
            Aws::SecretsManager::Errors::ResourceNotFoundException.new(
              nil, 'blah' # can't pass these vars in from raise
            )
          )
      end

      it 'should raise SecretNotFoundError' do
        expect { subject }.to raise_error described_class::SecretNotFoundError
      end
    end
  end
end
