# encoding: utf-8
require 'devise/mapping'

module Devise #:nodoc:
  module MeetupAuthenticatable #:nodoc:

    # OAuth2 view helpers to easily add the link to the OAuth2 connection popup and also the necessary JS code.
    #
    module Helpers
      
      # Creates the link to
      def link_to_meetup(link_text, options={})
        
        
        session_sign_in_url = Devise::session_sign_in_url(request,::Devise.mappings[:user])
      
        link_to link_text, Devise::meetup_client.request_token.authorize_url
        
      end


      
    end
  end
end

::ActionView::Base.send :include, Devise::MeetupAuthenticatable::Helpers