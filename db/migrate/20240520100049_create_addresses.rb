class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.string :full_address

      t.timestamps
    end
  end
end
