ActionDispatch::Routing::Mapper.class_eval do
  protected
  
  def devise_meetup(mapping, controllers)
    scope mapping.full_path do
      get mapping.path_names[:meetup], :to => "#{controllers[:sessions]}#create", :as => :"meetup_#{mapping.name}_session"
    end
  end
end

