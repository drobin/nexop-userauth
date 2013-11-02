module Nexop
  module Userauth
    class UserauthSuccess < Message::Base
      SSH_MSG_USERAUTH_SUCCESS = 52

      ##
      # @!attribute [r] type
      # @return [Integer] Message type set to {SSH_MSG_USERAUTH_SUCCESS}
      add_field(:type, type: :byte, const: SSH_MSG_USERAUTH_SUCCESS)
    end
  end
end
