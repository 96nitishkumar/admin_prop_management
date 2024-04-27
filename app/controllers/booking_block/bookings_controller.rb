class BookingBlock::BookingsController < ApplicationController
	 before_action :authenticate_user

	before_action :set_property, only: [:create]
	before_action :set_booking, only: [:accept_or_reject_booking]

	def create
		booking = @property.bookings.new(booking_params)
		booking.user_id = @current_user.id
		if booking.save
			render json: { data: BookingBlock::BookingSerializer.new(booking), message:"Property is booked for you" },status: 200
		else
			render json: { errors: booking.errors.full_messages, message:" booking failed" }, status: 422
		end
	end

	def accept_or_reject_booking
		if @booking.update(status: @status)
			render json: { data: @booking, message: "Booking updated successfull.." }, status: 200
		end
	end

	def cancel_booking
		booking = @current_user.bookings.where(status:[0,1]).find(params[:booking_id])
		if booking.transactions.blank?
			render json: {message: "you can not cancel the booking untill your transactions is completed" }, status: 422

		else
			if booking.transactions.last.completed? && booking.update(status: 3)
			 render json: {message: "your booking is canceled successfully" }, status: 200
			else
			 render json: {message: "you can not cancel the booking untill your transactions is completed" }, status: 422
			end
		end
	end

	def user_booking
		bookings = @current_user.bookings
		bookings = bookings.where(status: params[:status]) if ["accept", "rejected", "pending"].include?(params[:status])
		render json: { data: BookingBlock::BookingSerializer.new(bookings).serializable_hash, message: 'Your booking data'}, status: 200
	end

	def owner_booking
		property_ids = @current_user.properties.ids
		bookings = BookingBlock::Booking.where(property_id: property_ids)
		bookings = bookings.where(status:params[:status]) if ["pending","accept","rejected", "canceled"].include?(params[:status])
		render json: { data: BookingBlock::BookingSerializer.new(bookings).serializable_hash, message: 'Your booking data'}, status: 200
	end

	def show 
		booking = @current_user.bookings.find(params[:id])
		render json: { data: BookingBlock::BookingSerializer.new(booking).serializable_hash, message: "booking data" }, status: 200
	end

	private 

	def set_booking
		@booking = BookingBlock::Booking.where.not(status:[2,3]).find(params[:booking_id])
		@status = params[:status]
		if !["accept", "rejected"].include?(@status)
			 return render json: { errors: "Invalid params status" }, status: 422
		elsif @status == "accept" && @booking.accept?
			 return render json: { errors: "This Booking is already accept"}, status: 422 
		elsif @booking.property.user_id != @current_user.id
			 return render json: { errors: "You are not authorized to perform this action" }, status: 401
		end
	end

	def booking_params
		params.require(:booking).permit(:from_date, :to_date, :property_id)
	end

	def set_property
		@property = PropertyBlock::Property.find(booking_params[:property_id])
		return render json: { errors: "This is your property so you can't book" },status: 200 if @property.user_id == @current_user.id
		return render json: { errors: "This property is not availabe for booking"}, status: 200 if @property.pending?
	end
end
