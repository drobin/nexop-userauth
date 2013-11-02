require 'spec_helper'

describe Nexop::Userauth::UserauthSuccess do
  let(:msg) { Nexop::Userauth::UserauthSuccess.new }

  it "has a type field" do
    msg.type.should == Nexop::Userauth::UserauthSuccess::SSH_MSG_USERAUTH_SUCCESS
  end
end
