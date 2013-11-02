module Nexop
  module Userauth
    class Service < Service::Base
      def initialize
        super("ssh-userauth")
      end
    end
  end
end
