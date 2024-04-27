ActiveAdmin.register UserBlock::User, as: "User" do
  permit_params :name, :email, :password, :location

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :password
    column :location
    actions
  end
  controller do 
    def create 
      @user = UserBlock::User.new(resource_params.first)
      if @user.save

      else 
        render :new
      end
    end 
  end 

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :location
    end
    f.actions
  end

end
