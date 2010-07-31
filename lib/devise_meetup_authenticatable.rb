require 'devise'

require 'devise_meetup_authenticatable/schema'
require 'devise_meetup_authenticatable/strategy'
require 'devise_meetup_authenticatable/routes'

Devise.add_module(:meetup_authenticatable,
  :strategy => true,
  :model => 'devise_meetup_authenticatable/model',
  :controller => :sessions,
  :route => :meetup)

