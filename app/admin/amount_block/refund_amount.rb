ActiveAdmin.register AmountBlock::RefundAmount, as: "RefundAmount" do
  permit_params :transaction_id, :refund_amount, :user_id

  index do
    selectable_column
    id_column
    column :transaction_id
    column :refund_amount
    column :user_id
    actions
  end

  form do |f|
    f.inputs do
      f.input :transaction_id
      f.input :refund_amount
      f.input :user_id
    end
    f.actions
  end

end
