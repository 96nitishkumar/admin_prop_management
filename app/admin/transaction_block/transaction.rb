ActiveAdmin.register TransactionBlock::Transaction, as: "Transaction" do
  permit_params :booking_id, :amount, :status

  index do
    selectable_column
    id_column
    column :booking_id
    column :amount
    column :status
    actions
  end

  form do |f|
    f.inputs do
      f.input :booking_id
      f.input :amount
      f.input :status
    end
    f.actions
  end

end
