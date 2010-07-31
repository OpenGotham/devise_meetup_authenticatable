module Devise
  module Models
    module MeetupAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def find_by_meetup_token(meetup_token)
          find(:first, :conditions => {:meetup_token => meetup_token})
        end
      end
    end
  end
end

