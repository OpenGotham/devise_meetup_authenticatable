  ActionDispatch::Routing::Mapper.class_eval do
    alias_method :meetup_complete, :devise_session
  end
