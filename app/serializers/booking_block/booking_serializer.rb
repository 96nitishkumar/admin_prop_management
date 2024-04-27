class BookingBlock::BookingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :from_date, :to_date, :property_id, :user_id, :status, :total_price

  attributes :card_details do |object|
    if object.transactions.last&.completed? && object.transactions.last&.card_id.present?

      card_data = Stripe::Customer.retrieve_source(object.user.stripe_cust_id, object.transactions.last&.card_id)
        {
          brand: card_data.brand,
          last_4_digit: card_data.last4,
          exp_month: card_data.exp_month,
          exp_year: card_data.exp_year
        }
    end
  end 
end
