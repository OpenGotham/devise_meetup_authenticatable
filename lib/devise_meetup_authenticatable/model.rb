  
  module MeetupAuthenticatable

   module Models
     # Adds MeetupAuthenticatable support to your model. The whole workflow is deeply discussed in the
     # README. This module adds just a class +oauth_access_token+ helper to your model
     # which assists you on creating an access token. All the other OAuth hooks in
     # Devise must be implemented by yourself in your application.
     #
     # == Options
     #
     # Oauthable adds the following options to devise_for:
     #
     #   * +oauth_providers+: Which providers are avaialble to this model. It expects an array:
     #
     #       devise_for :database_authenticatable, :meetup_authenticatable, :oauth_providers => [:twitter]
     #
     module MeetupAuthenticatable
       
         def self.included(base) #:nodoc:
           base.class_eval do
             extend ClassMethods
           end
         end

         # Store meetup Connect account/session credentials.
         #
         def store_meetup_credentials!(attributes = {})
           self.send(:"#{self.class.meetup_uid_field}=", attributes[:uid])
           self.send(:"#{self.class.meetup_token_field}=", attributes[:token])

           # Confirm without e-mail - if confirmable module is loaded.
           self.skip_confirmation! if self.respond_to?(:skip_confirmation!)

           # Only populate +email+ field if it's available (e.g. if +authenticable+ module is used).
           self.email = attributes[:email] || '' if self.respond_to?(:email)

           # Lazy hack: These database fields are required if +authenticable+/+confirmable+
           # module(s) is used. Could be avoided with :null => true for authenticatable
           # migration, but keeping this to avoid unnecessary problems.
           self.password_salt = '' if self.respond_to?(:password_salt)
           self.encrypted_password = '' if self.respond_to?(:encrypted_password)
         end

         # Checks if meetup Connected.
         #
         def meetup_connected?
           self.send(:"#{self.class.meetup_uid_field}").present?
         end
         alias :is_meetup_connected? :meetup_connected?

         # Hook that gets called *before* connect (only at creation). Useful for
         # specifiying additional user info (etc.) from meetup.
         #
         # Default: Do nothing.
         #
         # == Examples:
         #
         #   # Overridden in meetup Connect:able model, e.g. "User".
         #   #
         #   def before_meetup_auto_create(meetup_user_attributes)

         #     self.profile.first_name = meetup_user_attributes.first_name

         #
         #   end
         #
         # == For more info:
         #
         #   * http://oauth2er.pjkh.com/user/populate
         #
         def on_before_meetup_auto_create(meetup_user_attributes)

           if self.respond_to?(:before_meetup_auto_create)
             self.send(:before_meetup_auto_create, meetup_user_attributes) rescue nil
           end
         end

         # Hook that gets called *after* a connection (each time). Useful for
         # fetching additional user info (etc.) from meetup.
         #
         # Default: Do nothing.
         #
         # == Example:
         #
         #   # Overridden in meetup Connect:able model, e.g. "User".
         #   #
         #   def after_meetup_connect(meetup_user_attributes)
         #     # See "on_before_meetup_connect" example.
         #   end
         #
         def on_after_meetup_connect(meetup_user_attributes)

           if self.respond_to?(:after_meetup_auto_create)
             self.send(:after_meetup_auto_create, meetup_user_attributes) rescue nil
           end
         end

         # Optional: Store session key.
         #
         def store_session(using_token)
           if self.token != using_token
             self.update_attribute(self.send(:"#{self.class.meetup_token_field}"), using_token)
           end
         end

       protected

       # Passwords are always required if it's a new rechord and no oauth_id exists, or if the password
       # or confirmation are being set somewhere.
       def password_required?

         ( new_record? && meetup_uid.nil? ) || !password.nil? || !password_confirmation.nil?
       end

         module ClassMethods

           # Configuration params accessible within +Devise.setup+ procedure (in initalizer).
           #
           # == Example:
           #
           #   Devise.setup do |config|
           #     config.meetup_uid_field = :meetup_uid
           #     config.meetup_token_field = :meetup_token
           #     config.meetup_auto_create_account = true
           #   end
           #
           ::Devise::Models.config(self,
               :meetup_uid_field,
               :meetup_token_field,
               :meetup_auto_create_account
             )

           # Alias don't work for some reason, so...a more Ruby-ish alias
           # for +meetup_auto_create_account+.
           #
           def meetup_auto_create_account?
             self.meetup_auto_create_account
           end

           # Authenticate a user based on meetup UID.
           #
           def authenticate_with_meetup(meetup_id, meetup_token)

               # find user and update access token 
               returning(self.find_for_meetup(meetup_id)) do |user|
                 user.update_attributes(:meetup_token => meetup_token) unless user.nil?
               end

           end

           protected



             # Find first record based on conditions given (meetup UID).
             # Overwrite to add customized conditions, create a join, or maybe use a
             # namedscope to filter records while authenticating.
             #
             # == Example:
             #
             #   def self.find_for_meetup(uid, conditions = {})
             #     conditions[:active] = true
             #     self.find_by_meetup_uid(uid, :conditions => conditions)
             #   end
             #
             def find_for_meetup(uid, conditions = {})

               self.find_by_meetup_uid(uid, :conditions => conditions)
             end



             # Contains the logic used in authentication. Overwritten by other devise modules.
             # In the meetup Connect case; nothing fancy required.
             #
             def valid_for_meetup(resource, attributes)
               true
             end

         end

       end
   end
end