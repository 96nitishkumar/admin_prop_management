class AddColumnToProperty < ActiveRecord::Migration[7.0]
  def change
    add_column :property_block_properties, :no_of_days, :integer, default: 0
    add_column :property_block_properties, :status, :integer, default: 0
  end
end
