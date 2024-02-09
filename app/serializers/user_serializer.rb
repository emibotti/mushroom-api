class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :organization_id
end
