module FaqBlock
	class FaqCategory < ApplicationRecord

		self.table_name = :faq_block_faq_categories

		has_many :question_answers, class_name: "FaqBlock::QuestionAnswer"

		validates :name, presence: true
		validates :description, presence: true

		def self.ransackable_associations(auth_object = nil)
	    	["question_answers"]
	  	end

	  	def self.ransackable_attributes(auth_object = nil)
	    	["created_at", "name", "id", "description","updated_at"]
	  	end

	end
end
