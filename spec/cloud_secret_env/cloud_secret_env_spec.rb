RSpec.describe CloudSecretEnv do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'returns a config object' do
      config = nil
      described_class.configure { |cse| config = cse }
      expect(config).to be_truthy
    end
  end

  describe '#run' do
    let!(:secrets) { { 'EXAMPLE_SECRET' => 'true' } }
    let!(:provider) { double(:provider, fetch_secrets!: secrets) }
    let!(:config) { nil }

    before do
      described_class.instance_variable_set(:@config, config)
      allow(described_class).to receive(:provider).and_return(provider)
    end

    context 'config is invalid' do
      let!(:config) { double(:config) }

      before do
        described_class.instance_variable_set(:@config, config)
      end
    end

    context 'config is valid' do
      let!(:config) do
        double(
          :config,
          secret_ids: ['derp'],
          validate!: true, verbose: true,
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
