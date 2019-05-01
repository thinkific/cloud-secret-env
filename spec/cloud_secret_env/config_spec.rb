# frozen_string_literal: true

RSpec.describe CloudSecretEnv::Config do # rubocop:disable Metrics/BlockLength
  let(:config) { described_class.new }

  describe '#provider=' do
    context 'provider is aws' do
      it 'should not raise a ProviderNotFound error' do
        expect do
          config.provider = CloudSecretEnv::AWS_PROVIDER
        end.not_to raise_error
      end
    end

    context 'provider does not exist' do
      it 'should raise a ProviderNotFound error' do
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
      it 'should set secret_ids to an array containing the string' do
        expect(subject).to eq([secret_id_string])
      end
    end

    context 'secret_ids is a comma-separated string' do
      let(:secret_id_string) { 'derp,derp2' }
      it 'should set secret_ids to an array with all pieces' do
        expect(subject).to eq(%w[derp derp2])
      end
    end

    context 'secret_ids is empty' do
      let(:secret_id_string) { '' }
      it 'should set secret_ids to an empty array' do
        expect(subject).to eq([])
      end
    end
  end

  describe '#validate!' do # rubocop:disable Metrics/BlockLength
    subject { config.validate! }

    context 'provider is blank' do
      it 'should fail validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'should notify failure due to Provider' do
        begin
          subject
        rescue described_class::ConfigValidationError => cve
          expect(cve.message).to include('Provider cannot be blank')
        end
      end
    end

    context 'region is blank' do
      it 'should fail validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'should notify failure due to Region' do
        begin
          subject
        rescue described_class::ConfigValidationError => cve
          expect(cve.message).to include('Region cannot be blank')
        end
      end
    end

    context 'secret_ids is empty' do
      it 'should fail validation' do
        expect { subject }.to raise_error described_class::ConfigValidationError
      end

      it 'should notify failure due to Secret IDs' do
        begin
          subject
        rescue described_class::ConfigValidationError => cve
          expect(cve.message).to include('Secret IDs cannot be empty')
        end
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

      it 'should pass validation' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
