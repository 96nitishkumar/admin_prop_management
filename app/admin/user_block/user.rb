ActiveAdmin.register UserBlock::User, as: "User" do
  permit_params :name, :email, :password, :location, addresses_attributes:[:full_address]

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :location

    column :address do |add|
      add.addresses.map{ |a| a.full_address}
    end
    column :latitude do |ad|
      ad.addresses.map{|a| a.latitude}
    end

    column :latitude do |ad|
      ad.addresses.map{|a| a.longitude}
    end

    actions
  end
  # controller do 
  #   def create 
  #     @user = UserBlock::User.new(resource_params.first)
  #     if @user.save

  #     else 
  #       render :new
  #     end
  #   end 
  # end 

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :location
      f.has_many :addresses do |add|
      add.input :full_address
    end
    end
    f.actions
  end



end
