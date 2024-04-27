FactoryBot.define do
  factory :property_block_property, class: 'PropertyBlock::Property' do
    property_name { "MyString" }
    cost_per_day { "9.99" }
    location { "MyString" }
  end
end
