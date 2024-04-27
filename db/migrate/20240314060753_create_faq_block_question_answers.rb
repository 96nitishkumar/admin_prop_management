class CreateFaqBlockQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :faq_block_question_answers do |t|
      t.string :question
      t.text :answer
      t.bigint :faq_category_id

      t.timestamps
    end
  end
end
