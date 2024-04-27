FactoryBot.define do
  factory :faq_block_question_answer, class: 'FaqBlock::QuestionAnswer' do
    question { "MyString" }
    answer { "MyText" }
    faq_category_id { "" }
  end
end
