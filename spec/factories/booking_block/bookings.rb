FactoryBot.define do
  factory :booking_block_booking, class: 'BookingBlock::Booking' do
    from_date { Date.today}
    to_date { Date.today +2.days}
    total_price { "9.99" }
  end
end
