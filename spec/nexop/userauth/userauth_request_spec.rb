require 'spec_helper'

describe Nexop::Userauth::UserauthRequest do
  let(:msg) { Nexop::Userauth::UserauthRequest.new }

  it "has a type field" do
    msg.type.should == Nexop::Userauth::UserauthRequest::SSH_MSG_USERAUTH_REQUEST
  end

  it "has a user_name field" do
    msg.user_name.should be_nil
  end

  it "has a service_name field" do
    msg.service_name.should be_nil
  end

  it "has a method_name field" do
    msg.method_name.should be_nil
  end
end
