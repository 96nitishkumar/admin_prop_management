ActiveAdmin.register PropertyBlock::Property, as: "Property" do
  permit_params :property_name, :cost_per_day, :location, :user_id, :no_of_days, :status

  index do
    selectable_column
    id_column
    column :property_name
    column :cost_per_day
    column :location
    column :user_id
    column :no_of_days
    column :status
    actions
  end

  form do |f|
    f.inputs do
      f.input :property_name
      f.input :cost_per_day
      f.input :location
      f.input :user_id
      f.input :no_of_days
      f.input :status
    end
    f.actions
  end

end
