Devise::Schema.class_eval do
  def meetup_authenticatable
    if respond_to?(:apply_devise_schema)
      apply_devise_schema :meetup_token, String
    else
      apply_schema :meetup_token, String
    end
  end
end