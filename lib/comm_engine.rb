require 'twilio-ruby'

module CommEngine
   class << self

      def sendViaSMS(to, msg)
	 account_sid = 'ACbd595dc7f89f7fe4771a0c24fa946a03'
	 auth_token = 'd8c46838d1c9b3ab0c9cf8eae4cd4b86'

	 @client = Twilio::REST::Client.new account_sid, auth_token

	 message = @client.account.messages.create(:body => msg,
						   :to => to,
						   :from => "+17474445981")

      end
   end
end
