class CreatePropertyBlockProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :property_block_properties do |t|
      t.string :property_name
      t.decimal :cost_per_day, default: 0
      t.string :location
      t.bigint :user_id
      t.timestamps
    end
  end
end
