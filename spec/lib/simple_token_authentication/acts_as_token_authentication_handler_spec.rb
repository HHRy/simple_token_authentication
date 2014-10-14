require 'spec_helper'

def ignore_cucumber_hack
  skip_rails_test_environment_code
end

# Skip the code intended to be run in the Rails test environment
def skip_rails_test_environment_code
  rails = double()
  stub_const('Rails', rails)
  rails.stub_chain(:env, :test?).and_return(false)
end

describe 'A class which can act as token authentication handler (or one of its children)' do

  after(:each) do
    ensure_examples_independence
  end

  before(:each) do
    define_test_subjects_for(SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler)
  end

  it 'responds to :acts_as_token_authentication_handler_for', public: true do
    @subjects.each do |subject|
      expect(subject).to respond_to :acts_as_token_authentication_handler_for
    end
  end

  it 'responds to :acts_as_token_authentication_handler', public: true, deprecated: true do
    @subjects.each do |subject|
      expect(subject).to respond_to :acts_as_token_authentication_handler
    end
  end
end

describe SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler do

  after(:each) do
    ensure_examples_independence
  end

  before(:each) do
    define_test_subjects_for(SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler)
  end

  describe '#acts_as_token_authentication_handler_for' do

    it 'ensures the receiver class does handle token authentication for a given (token authenticatable) model' do
      double_user_model

      @subjects.each do |subject|
        subject.stub(:before_filter)

        expect(subject).to receive(:include).with(SimpleTokenAuthentication::TokenAuthenticationHandler)
        expect(subject).to receive(:include).with(SimpleTokenAuthentication::ActsAsTokenAuthenticationHandlerMethods)
        expect(subject).to receive(:handle_token_authentication_for).with(User, { option: 'value' })

        subject.acts_as_token_authentication_handler_for User, { option: 'value' }
      end
    end
  end
end
