# frozen_string_literal: true

RSpec.describe CloudSecretEnv do # rubocop:disable Metrics/BlockLength
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

  describe '#run' do # rubocop:disable Metrics/BlockLength
    let!(:secrets) { { 'EXAMPLE_SECRET' => 'true' } }
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

      it 'should throw an error' do
        expect { subject }.to raise_exception(described_class::Config::ConfigValidationError)
      end
    end

    context 'config is valid' do
      let!(:config) do
        double(
          :config,
          secret_ids: ['derp'],
          validate!: true,
          verbose: false,
          override: false
        )
      end

      it 'should set the env' do
        described_class.run
        env_val = secrets['EXAMPLE_SECRET']
        expect(ENV['EXAMPLE_SECRET']).to eq(env_val)
      end
    end
  end
end
