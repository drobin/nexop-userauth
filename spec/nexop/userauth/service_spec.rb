require 'spec_helper'

describe Nexop::Userauth::Service do
  let(:service) { Nexop::Userauth::Service.new }

  it "has the correct name" do
    service.name.should == "ssh-userauth"
  end

  context "available_methods" do
    it "is empty" do
      service.available_methods.should be_empty
    end
  end

  context "tick" do
    let(:request) { Nexop::Userauth::UserauthRequest.new(:user_name => "un", :service_name => "sn", :method_name => "mn") }

    it "receives a SSH_MSG_USERAUTH_REQUEST and responds with SSH_MSG_DISCONNECT" do
      service.tick(request.serialize).should be_an_instance_of(Nexop::Message::Disconnect)
    end
  end
end
