class PropertyBlock::PropertySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :property_name, :cost_per_day, :location, :user_id, :no_of_days, :status
end
