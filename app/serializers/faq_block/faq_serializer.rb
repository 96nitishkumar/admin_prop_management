class FaqBlock::FaqSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :question

  # attributes :category_data do |object|
  #   FaqBlock::FaqCategory.find(object.faq_category_id)
  # end


end
