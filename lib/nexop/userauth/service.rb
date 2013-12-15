module Nexop
  module Userauth
    ##
    # Implementation of of _ssh-userauth_ service.
    #
    # @see http://tools.ietf.org/html/rfc452
    class Service < Service::Base
      include Nexop::Log

      ##
      # Create a new instance of the service-class.
      def initialize
        super("ssh-userauth")
      end

      ##
      # Returns a list of all available authentication-methods.
      #
      # This list is dynamically build up based on all assigned
      # authentication-callbacks.
      #
      # Due to the fact, that currently no methods are implemented, this list
      # is empty at any time.
      #
      # @return [Array] An array with all enabled authentication methods, which
      #         is currently empty at any time.
      def available_methods
        []
      end

      def tick(payload)
        UserauthRequest.parse(payload)
        return UserauthSuccess.new
      end
    end
  end
end
