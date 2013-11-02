module Nexop
  module Userauth
    class UserauthFailure < Message::Base
      SSH_MSG_USERAUTH_FAILURE = 51

      ##
      # @!attribute [r] type
      # @return [Integer] Message type set to {SSH_MSG_USERAUTH_FAILURE}
      add_field(:type, type: :byte, const: SSH_MSG_USERAUTH_FAILURE)

      ##
      # @!attribute [rw] continue
      # @return [Array] Authentications that can continue. This is a
      #         comma-separated name-list of authentication 'method name'
      #         values that may productively continue the authentication
      #         dialog.
      add_field(:continue, type: :name_list, default: [])

      ##
      # @!attribute [rw] partial
      # @return [Boolean] Partial success. The value of 'partial success'
      #         must be `true` if the authentication request to which this is
      #         a response was successful. It must be `false` if the request
      #         was not successfully processed.
      add_field(:partial, type: :boolean)
    end
  end
end
