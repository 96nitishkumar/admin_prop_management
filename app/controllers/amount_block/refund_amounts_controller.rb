class AmountBlock::RefundAmountsController < ApplicationController

	  before_action :authenticate_user

	def index 
		refunds = @current_user.refund_amounts
		render json: { refunds_data: refunds, message: "your refund list" }, status: 200
	end
end
