# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  controller do
    before_action :authenticate_admin_user!

    private

    def authenticate_admin_user!
      redirect_to new_admin_user_session_path unless current_admin_user
    end
  end

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        h1 "Welcome To Admin Dashboard"
      end
    end

    columns do
      column do
        div class: "b1" do 
          div class: "d1" do 
            panel "User List" do
              ul do
                UserBlock::User.all.each do |user|
                  li link_to(user.name, admin_user_path(user))
                end
                h5 "Total User: #{UserBlock::User.count}"
              end
            end
          end
          div class: "d2" do 
            panel "Property List" do
              ul do
                PropertyBlock::Property.all.each do |prop|
                  li link_to(prop.property_name, admin_property_path(prop))
                end
                h5 "Total Property: #{PropertyBlock::Property.count}"
              end
            end
          end
          div class: "d3" do 
            panel "Booking Property List" do
              ul do
                BookingBlock::Booking.all.each do |booking|
                  li link_to(booking.property.property_name, admin_booking_path(booking))
                end
                h5 "Total Order: #{BookingBlock::Booking.count}"
              end
            end
          end
        end

        end
      end
  end # content
end
