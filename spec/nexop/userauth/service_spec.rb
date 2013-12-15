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

    it "contains :password when the password method is enabled" do
      service.password {}
      service.available_methods.should include(:password)
    end
  end

  context "password" do
    it "returns the service itself useful for method chaining" do
      result = service.password {}
      result.should be_equal(service)
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

    context "password method" do
      let(:request) { Nexop::Userauth::UserauthRequest.new(:user_name => "un", :service_name => "sn", :method_name => "password", :password => "abc") }
      let(:callback) { Proc.new{} }

      it "aborts the session if a password change response was received" do
        request.false_value = true
        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Message::Disconnect)
        response.reason_code.should == Nexop::Message::Disconnect::Reason::PROTOCOL_ERROR
      end

      it "aborts the request if no callback is available" do
        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Userauth::UserauthFailure)
        response.partial.should be_false
      end

      it "passes username and password to the callback" do
        callback.should_receive(:call).with("un", "abc")
        service.password(&callback)
        service.tick(request.serialize)
      end

      it "aborts the request when the callback fails" do
        callback.should_receive(:call).and_return(false)
        service.password(&callback)
        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Userauth::UserauthFailure)
        response.partial.should be_false
      end

      it "succeeds the request when the calback also succeeds" do
        callback.should_receive(:call).and_return(true)
        service.password(&callback)
        response = service.tick(request.serialize)
        response.should be_an_instance_of(Nexop::Userauth::UserauthSuccess)
      end
    end
  end
end
