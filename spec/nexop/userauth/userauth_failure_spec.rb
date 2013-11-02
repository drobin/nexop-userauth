require 'spec_helper'

describe Nexop::Userauth::UserauthFailure do
  let(:msg) { Nexop::Userauth::UserauthFailure.new }

  it "has a type field" do
    msg.type.should == Nexop::Userauth::UserauthFailure::SSH_MSG_USERAUTH_FAILURE
  end

  it "has a continue field" do
    msg.continue.should be_empty
  end

  it "has a partial field" do
    msg.partial.should be_nil
  end
end
