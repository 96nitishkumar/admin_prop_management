class FaqBlock::FaqsController < ApplicationController

	before_action :authenticate_user

	def index 
		categories = FaqBlock::FaqCategory.all
		categories = categories.where("name ILIKE ?", "%#{params[:text]}%") if params[:text].present? 
		render json: { data: categories, messages: "All categories list"}, status: 200
	end

	def question_list
		category = FaqBlock::FaqCategory.find(params[:category_id])
		question_list = category.question_answers
		question_list = question_list.where("question ILIKE ?", "%#{params[:text]}%") if params[:text].present?
		questions = FaqBlock::FaqSerializer.new(question_list).serializable_hash
		data = {}
		 data[:category] = category
		 data[:questions] = questions
		render json: { questions: data, messages: "All questions list"}, status: 200
	end

	def show 
		questions_answer = FaqBlock::QuestionAnswer.find(params[:id])
		render json: { question: questions_answer, messages: "Question answers"}, status: 200
	end

end
