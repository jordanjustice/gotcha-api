require "fast_jsonapi"

class PlayerSerializer
  include FastJsonapi::ObjectSerializer

  set_type :player
  attributes :api_key, :avatar, :email_address, :name
end
