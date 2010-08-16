# encoding: utf-8
require 'devise/schema'

module Devise #:nodoc:
  module MeetupAuthenticatable #:nodoc:

    module Schema

      # Database migration schema for meetup.
      #
      def meetup_authenticatable
        apply_devise_schema ::Devise.meetup_uid_field, Integer, :limit => 8 # BIGINT unsigned / 64-bit int
        apply_devise_schema ::Devise.meetup_token_field, String, :limit => 149 # [128][1][20] chars
      end

    end
  end
end

Devise::Schema.module_eval do
  include ::Devise::MeetupAuthenticatable::Schema
end