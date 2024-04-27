class CreateBookingBlockBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_block_bookings do |t|
      t.datetime :from_date
      t.datetime :to_date
      t.decimal :total_price, default: 0
      t.integer :status, default: 0
      t.bigint :user_id
      t.bigint :property_id

      t.timestamps
    end
  end
end
