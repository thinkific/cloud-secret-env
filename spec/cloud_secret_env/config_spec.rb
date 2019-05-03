# frozen_string_literal: true

RSpec.describe CloudSecretEnv::Config do
  let(:config) { described_class.new }

  describe '#provider=' do
    context 'provider is aws' do
      it 'does not raise a ProviderNotFound error' do
        expect do
          config.provider = CloudSecretEnv::AWS_PROVIDER
        end.not_to raise_error
      end
    end

    context 'provider does not exist' do
      it 'raises a ProviderNotFound error' do
        expect do
          config.provider = 'derp'
        end.to raise_error CloudSecretEnv::ProviderNotFound
      end
    end
  end

  describe '#secret_ids=' do
    subject { config.secret_ids }
    before { config.secret_ids = secret_id_string }

    context 'secret_ids is a string with no commas' do
      let(:secret_id_string) { 'derp' }
      it 'sets secret_ids to an array containing the string' do
        expect(subject).to eq([secret_id_string])
      end
    end

    context 'secret_ids is a comma-separated string' do
      let(:secret_id_string) { 'derp,derp2' }
      it 'sets secret_ids to an array with all pieces' do
        expect(subject).to eq(%w[derp derp2])
      end
    end

    context 'secret_ids is empty' do
      let(:secret_id_string) { '' }
      it 'sets secret_ids to an empty array' do
        expect(subject).to eq([])
      end
    end
  end

  describe '#validate!' do
    subject { config.validate! }

    def error_message
      subject
    rescue described_class::ConfigValidationError => cve
      cve.message
    end

    context 'provider is blank' do
      it 'fails validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'notifies failure due to Provider' do
        expect(error_message).to include('Provider cannot be blank')
      end
    end

    context 'region is blank' do
      it 'fails validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'notifies failure due to Region' do
        expect(error_message).to include('Region cannot be blank')
      end
    end

    context 'secret_ids is empty' do
      it 'fails validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'notifies failure due to Secret IDs' do
        expect(error_message).to include('Secret IDs cannot be empty')
      end
    end

    context 'config is valid' do
      let!(:config) do
        cfg = described_class.new
        cfg.provider = 'aws'
        cfg.region = 'derp'
        cfg.secret_ids = 'abc'
        cfg
      end

      it 'passes validation' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
