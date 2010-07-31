require 'devise/strategies/base'
require 'rack/oauth'

module Devise
  module Strategies
    class MeetupAuthenticatable < Base
      
      include Rack::OAuth::Methods
      
      
      def valid?
        get_access_token.present?
        
      end

      def authenticate!
        logger.debug("Authenticating with Meetup for mapping #{mapping.to}")
        session[:info] = get_access_token.get('/account/verify_credentials.json').body
      end
      
      private
   
      
      def logger
        @logger ||= ((Rails && Rails.logger) || RAILS_DEFAULT_LOGGER)
      end
    end
  end
end

Warden::Strategies.add(:meetup_authenticatable, Devise::Strategies::MeetupAuthenticatable)

