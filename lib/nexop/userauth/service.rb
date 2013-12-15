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
        request = UserauthRequest.parse(payload)
        log.debug("UserauthRequest received: " +
                  "#{request.user_name}, " +
                  "#{request.service_name}, " +
                  "#{request.method_name}")

        response = Nexop::Message::Disconnect.new(
          :reason_code => Nexop::Message::Disconnect::Reason::NO_MORE_AUTH_METHODS_AVAILABLE,
          :description => "authentication method '#{request.method_name}' is not supported"
        )
        log.debug("Disconnect send [#{response.reason_code}, #{response.description}]")
        return response
      end
    end
  end
end
