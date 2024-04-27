ActiveAdmin.register FaqBlock::QuestionAnswer, as: "QuestionAnswer" do
  permit_params :faq_category_id, :question, :answer

  index do
    selectable_column
    id_column
    column :faq_category do |question|
      question.faq_category.name
    end
    column :question
    column :answer
    actions
  end

  form do |f|
    f.inputs do
      f.input :faq_category, as: :select, collection: FaqBlock::FaqCategory.all.map { |c| [c.name, c.id] }
      f.input :question
      f.input :answer
    end
    f.actions
  end

end
