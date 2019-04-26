# require 'spec_helper'
# require 'tmpdir'

# RSpec.describe AwsSecretEnv::Parser do

#   describe '.parse' do
#     subject { AwsSecretEnv::Parser.parse(directory, config_pattern, credential_pattern) }
#     let(:config_pattern) { '[profile think-dev]' }
#     let(:credential_pattern) { '[think-new]'}

#     context 'file existence' do
#       context 'no files in directory' do
#         let(:directory) { 'blah' }
#         it 'should raise an error' do 
#           expect { subject }.to raise_error AwsSecretEnv::Parser::FileNotFound
#         end
#       end

#       context 'config but no credential' do
#         before(:all) do 
#           @dir = Dir.mktmpdir
#           FileUtils.cp 'spec/files/config', "#{@dir}/config"
#         end
#         after(:all) { FileUtils.remove_entry @dir }

#         let(:directory) { @dir }
#         it 'should raise an error' do
#           expect { subject }.to raise_error AwsSecretEnv::Parser::FileNotFound
#         end
#       end

#       context 'config and credential' do
#         before(:all) do 
#           @dir = Dir.mktmpdir
#           FileUtils.cp 'spec/files/config', "#{@dir}/config"
#           FileUtils.cp 'spec/files/credentials', "#{@dir}/credentials"
#         end
#         after(:all) { FileUtils.remove_entry @dir }

#         let(:directory) { @dir }
#         it 'should not raise an error' do
#           expect { subject }.not_to raise_error
#         end
#       end
#     end

#     context 'pattern existence' do
#       context 'pattern not in config or credential' do
#         before(:all) do
#           @dir = Dir.mktmpdir
#           FileUtils.touch "#{@dir}/config"
#           FileUtils.touch "#{@dir}/credentials"
#         end
#         after(:all) { FileUtils.remove_entry @dir }

#         let(:directory) { @dir }

#         it 'should raise an error' do
#           expect { subject }.to raise_error AwsSecretEnv::Parser::PatternNotFound
#         end
#       end

#       context 'pattern in config but not credential' do
#         before(:all) do
#           @dir = Dir.mktmpdir
#           FileUtils.cp 'spec/files/config', "#{@dir}/config"
#           FileUtils.touch "#{@dir}/credentials"
#         end
#         after(:all) { FileUtils.remove_entry @dir }

#         let(:directory) { @dir }

#         it 'should raise an error' do
#           expect { subject }.to raise_error AwsSecretEnv::Parser::PatternNotFound
#         end
#       end

#       context 'pattern in config and credential' do
#         before(:all) do
#           @dir = Dir.mktmpdir
#           FileUtils.cp 'spec/files/config', "#{@dir}/config"
#           FileUtils.cp 'spec/files/credentials', "#{@dir}/credentials"
#         end
#         after(:all) { FileUtils.remove_entry @dir }

#         let(:directory) { @dir }

#         it 'should not raise an error' do
#           expect { subject }.not_to raise_error
#         end
#       end
#     end
#   end
# end