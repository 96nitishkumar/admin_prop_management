ActiveAdmin.register BookingBlock::Booking, as: "Booking" do
  permit_params :property_id, :from_date, :to_date, :user_id, :status,

  index do
    selectable_column
    id_column
    column :property_id
    column :from_date
    column :to_date
    column :user_id
    column :status
    column :total_price
    actions
  end

  form do |f|
    f.inputs do
      f.input :property_id
      f.input :from_date
      f.input :to_date
      f.input :user_id
      f.input :status
    end
    f.actions
  end

end
