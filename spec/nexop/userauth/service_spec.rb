require 'spec_helper'

describe Nexop::Userauth::Service do
  let(:service) { Nexop::Userauth::Service.new }

  it "has the correct name" do
    service.name.should == "ssh-userauth"
  end
end
