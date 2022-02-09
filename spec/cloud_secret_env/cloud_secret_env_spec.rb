# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe CloudSecretEnv do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  it 'has an AWS_PROVIDER' do
    expect(described_class::AWS_PROVIDER).to eq(:aws)
  end

  it 'has PROVIDERS' do
    expect(described_class::PROVIDERS).not_to be_empty
  end

  describe '#configure' do
    it 'returns a config object' do
      config = nil
      described_class.configure { |cse| config = cse }
      expect(config).to be_truthy
    end
  end

  describe '#run' do
    let!(:secrets) { { 'EXAMPLE_SECRET' => 'true', 'ANOTHER_EXAMPLE_SECRET' => 'test' } }
    let!(:provider) { double(:provider, fetch_secrets!: secrets) }
    let!(:config) { nil }

    subject { described_class.run }

    before do
      described_class.instance_variable_set(:@config, config)
      allow(described_class).to receive(:provider).and_return(provider)
    end

    context 'config is invalid' do
      let!(:config) { described_class::Config.new }

      before do
        described_class.instance_variable_set(:@config, config)
      end

      it 'throws an error' do
        expect { subject }.to raise_exception(described_class::Config::ConfigValidationError)
      end
    end

    context 'config is valid with override set to false' do
      let!(:config) do
        double(
          :config,
          secret_ids: ['derp'],
          validate!: true,
          verbose: false,
          override: false
        )
      end

      before do
        ENV['EXAMPLE_SECRET'] = 'foo'
      end

      it 'successfully updates the env without overriding existing values' do
        described_class.run
        expect(ENV['EXAMPLE_SECRET']).to eq('foo')
        expect(ENV['ANOTHER_EXAMPLE_SECRET']).to eq(secrets['ANOTHER_EXAMPLE_SECRET'])
      end
    end

    context 'config is valid with override set to true' do
      let!(:config) do
        double(
          :config,
          secret_ids: ['derp'],
          validate!: true,
          verbose: false,
          override: true
        )
      end

      before do
        ENV['EXAMPLE_SECRET'] = 'foo'
      end

      it 'successfully updates the env and overrides existing values' do
        described_class.run
        expect(ENV['EXAMPLE_SECRET']).to eq(secrets['EXAMPLE_SECRET'])
        expect(ENV['ANOTHER_EXAMPLE_SECRET']).to eq(secrets['ANOTHER_EXAMPLE_SECRET'])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
