class UserBlock::UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :location
end
