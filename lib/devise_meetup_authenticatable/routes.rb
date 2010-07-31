  ActionDispatch::Routing::Mapper.class_eval do
    
   # map.after_login 'oauth_complete', :controller => 'meetup_callback', :action => 'after_login'
   alias_method :oauth_complete, :devise_session
  end

end