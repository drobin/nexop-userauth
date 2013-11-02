module Nexop
  module Userauth
    class Service < Service::Base
      def initialize
        super("ssh-userauth")
      end

      def tick(payload)
        UserauthRequest.parse(payload)
        return UserauthSuccess.new
      end
    end
  end
end
