# encoding: utf-8
require 'devise/strategies/base'


module Devise #:nodoc:
  module MeetupAuthenticatable #:nodoc:
    module Strategies #:nodoc:

      # Default strategy for signing in a user using Facebook Connect (a Facebook account).
      # Redirects to sign_in page if it's not authenticated
      #
      class MeetupAuthenticatable < ::Devise::Strategies::Base
        
        

        # Without a oauth session authentication cannot proceed.
        #
        def valid?
          
         valid_controller? && valid_params? && mapping.to.respond_to?('authenticate_with_meetup')
          
        end

        # Authenticate user with meetup
        #
        def authenticate!
          klass = mapping.to
          begin


            # Verify User Auth code and get access token from auth server: will error on failue
            access_token = Devise::meetup_client.request_token.get_access_token
            
                  
            # retrieve user attributes
            
            # Get user details from meetup Service
            # NOTE: Facebook Graph Specific
            # TODO: break this out into separate model or class to handle
            # different meetup providers
            meetup_user_attributes = JSON.parse(access_token.get('/me'))
      
            user = klass.authenticate_with_meetup(meetup_user_attributes['id'], access_token.token)



            if user.present?
              user.on_after_meetup_connect(meetup_user_attributes)
              success!(user)
            else
              if klass.meetup_auto_create_account?
                
                
                
                user = returning(klass.new) do |u|
                  u.store_meetup_credentials!(
                      :token => access_token.token,
                      :uid => meetup_user_attributes['id']
                    )
                  u.on_before_meetup_auto_create(meetup_user_attributes)
                end

                begin
                  
                  
                  user.save(true)
                  user.on_after_meetup_connect(meetup_user_attributes)
                  
                  
                  success!(user)
                rescue
                  fail!(:meetup_invalid)
                end
              else
                fail!(:meetup_invalid)
              end
            end
          
          rescue => e
            fail!(e.message)
          end
        end
        

        
        
        protected
          def valid_controller?
            # params[:controller] == 'sessions'
            mapping.controllers[:sessions] == params[:controller]
          end

          def valid_params?
            params[:code].present?
          end

      end
    end
  end
end

Warden::Strategies.add(:meetup_authenticatable, Devise::MeetupAuthenticatable::Strategies::MeetupAuthenticatable)

