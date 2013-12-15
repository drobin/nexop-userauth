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
      # Currently implemented authentication methods are are:
      #
      # * `:password`: {#password password authentication}
      #
      # Due to the fact, that currently no methods are implemented, this list
      # is empty at any time.
      #
      # @return [Array] An array with all enabled authentication methods, which
      #         is currently empty at any time.
      def available_methods
        (@authentication_methods || {}).keys
      end

      ##
      # Assign a callback to enable _password authentication_.
      #
      # As soon as an callback is assigned here, _password authentication_ is
      # enabled for the service.
      #
      # The assigned `Proc`-instance will get two arguments:
      #
      # 1. The username of the authentication request,
      # 2. The password received from the client.
      #
      # The return value of the callback decides how to handle the
      # authentication attempt. If `true` is returned, then the authentication
      # attept is successful and the whole service succeeds. Any other value
      # will lead into an authentication failure.
      #
      # @param blk [Proc] The callback which is called for
      #        _password authentication_.
      # @return [Service] The instance of the service
      def password(&blk)
        @authentication_methods ||= {}
        @authentication_methods[:password] = blk
        self
      end

      def tick(payload)
        request = UserauthRequest.parse(payload)
        log.debug("UserauthRequest received: " +
                  "#{request.user_name}, " +
                  "#{request.service_name}, " +
                  "#{request.method_name}")

        return tick_none if request.method_name == "none"
        return tick_password(request) if request.method_name == "password"

        response = Nexop::Message::Disconnect.new(
          :reason_code => Nexop::Message::Disconnect::Reason::NO_MORE_AUTH_METHODS_AVAILABLE,
          :description => "authentication method '#{request.method_name}' is not supported"
        )
        log.debug("Disconnect send [#{response.reason_code}, #{response.description}]")
        return response
      end

      private

      def tick_none
        log.debug("available authentication methods: #{available_methods.join(',')}")

        if available_methods.empty?
          # You don't have any available methods. It's better to disconnect now
          response = Nexop::Message::Disconnect.new(
            :reason_code => Nexop::Message::Disconnect::Reason::NO_MORE_AUTH_METHODS_AVAILABLE,
            :description => "no authentication methods available"
          )
          log.debug("Disconnect send [#{response.reason_code}, #{response.description}]")
        else
          # Send back all available authentication methods
          response = UserauthFailure.new(:continue => available_methods, :partial => true)
          log.debug("UserauthFailure send [#{response.continue.join(',')}, #{response.partial}]")
        end

        return response
      end

      def tick_password(request)
        log.debug("password authentication request for #{request.user_name}")

        if request.false_value
          log.error("protocol error, password change not supported not expected")

          response = Nexop::Message::Disconnect.new(
            :reason_code => Nexop::Message::Disconnect::Reason::PROTOCOL_ERROR,
            :description => "protocol error, password change not supported nor expected"
          )
          log.debug("Disconnect send [#{response.reason_code}, #{response.description}]")

          return response
        end

        callback = authentication_callback(:password)

        unless callback
          log.error("no callback for password authentication available, aborting")

          response = UserauthFailure.new(:continue => available_methods, :partial => false)
          log.debug("UserauthFailure send [#{response.continue.join(',')}, #{response.partial}]")

          return response
        end

        if callback.call(request.user_name, request.password)
          log.debug("UserauthSuccess send")
          return UserauthSuccess.new
        else
          response = UserauthFailure.new(:continue => available_methods, :partial => false)
          log.debug("UserauthFailure send [#{response.continue.join(',')}, #{response.partial}]")

          return response
        end
      end

      def authentication_callback(method)
        @authentication_methods[method] if @authentication_methods
      end
    end
  end
end
