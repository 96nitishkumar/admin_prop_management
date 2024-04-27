
module FaqBlock
	class QuestionAnswer < ApplicationRecord

		self.table_name = :faq_block_question_answers

		belongs_to :faq_category, class_name: "FaqBlock::FaqCategory"
		validates :question, presence: true
		validates :answer, presence: true


		def self.ransackable_associations(auth_object = nil)
	    	["faq_category"]
	  	end

	  	def self.ransackable_attributes(auth_object = nil)
	    	["created_at", "question", "id", "answer","updated_at"]
	  	end
	end
end
