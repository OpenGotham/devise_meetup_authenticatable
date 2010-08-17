
  require 'devise'
  require 'oauth'
  require 'devise_meetup_authenticatable/model'
  require 'devise_meetup_authenticatable/strategy'
  require 'devise_meetup_authenticatable/schema'
  require 'devise_meetup_authenticatable/routes'
  require 'devise_meetup_authenticatable/view_helpers'


module Devise
  
  mattr_accessor :meetup_uid_field
  @@meetup_uid_field = :meetup_uid

  # Specifies the name of the database column name used for storing
  # the user Facebook session key. Useful if this info should be saved in a
  # generic column if different authentication solutions are used.
  mattr_accessor :meetup_token_field
  @@meetup_token_field = :meetup_token

  # Specifies if account should be created if no account exists for
  # a specified Facebook UID or not.
  mattr_accessor :meetup_auto_create_account
  @@meetup_auto_create_account = true
  
  def self.meetup_client
    @@meetup_client ||= OAuth::Consumer.new("ABDAE5ED0962D3332A0B546174997828", "856263601BB15FA05D1062AA082FF6CD", :site => "http://www.meetup.com/", :request_token_url => "http://www.meetup.com/oauth/request/", :authorize_path => 'authorize/', :access_token_path => 'oauth/access/', :oauth_callback => "oob", :http_method => :post)
    
  end
  
  
  def self.session_sign_in_url(request, mapping)
    url = URI.parse(request.url)
    # url.path = "#{mapping.parsed_path}/#{mapping.path_names[:sign_in]}"
    url.path = "#{mapping.full_path}/#{mapping.path_names[:meetup]}"
    url.query = nil
    url.to_s
  end
  
  def self.requested_scope
    @@requested_scope ||= 'meetup'
  end
  
end 
  



Devise.add_module(:meetup_authenticatable,
  :strategy => true,
  :controller => :sessions,
  :route => :meetup,
  :model => 'devise_meetup_authenticatable/model')