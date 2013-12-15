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

    context "none method" do
      let(:request) { Nexop::Userauth::UserauthRequest.new(:user_name => "un", :service_name => "sn", :method_name => "none") }

      it "disconnects, when no authentication methods are available" do
        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Message::Disconnect)
        response.reason_code.should == Nexop::Message::Disconnect::Reason::NO_MORE_AUTH_METHODS_AVAILABLE
      end

      it "sends back all available authentication methods" do
        service.stub(:available_methods) { ["abc", "def"] }

        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Userauth::UserauthFailure)
        response.continue.should == [ "abc", "def" ]
        response.partial.should be_true
      end
    end

    it "receives a SSH_MSG_USERAUTH_REQUEST and responds with SSH_MSG_DISCONNECT" do
      service.tick(request.serialize).should be_an_instance_of(Nexop::Message::Disconnect)
    end
  end
end
