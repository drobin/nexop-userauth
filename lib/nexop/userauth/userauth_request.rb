module Nexop
  module Userauth
    class UserauthRequest < Message::Base
      SSH_MSG_USERAUTH_REQUEST = 50

      ##
      # @!attribute [r] type
      # @return [Integer] Message type set to {SSH_MSG_USERAUTH_REQUEST}
      add_field(:type, type: :byte, const: SSH_MSG_USERAUTH_REQUEST)

      ##
      # @!attribute [rw] user_name
      # @return [String] user name
      add_field(:user_name, type: :string)

      ##
      # @!attribute [rw] service_name
      # @return [String] Name of service to start after authentication
      #         succeeds.
      add_field(:service_name, type: :string)

      ##
      # @!attribute [rw] method_name
      # @return [String] Authentication method
      add_field(:method_name, type: :string)

      add_field(:false_value, type: :boolean, default: false, if: Proc.new{ |msg| msg.method_name == "password" })
      add_field(:password, type: :string, if: Proc.new{ |msg| msg.method_name == "password" })
    end
  end
end
