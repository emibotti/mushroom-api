class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :organization_id
end
