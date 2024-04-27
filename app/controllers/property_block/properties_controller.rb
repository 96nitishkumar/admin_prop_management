class PropertyBlock::PropertiesController < ApplicationController
	before_action :set_property, only: [:update, :destroy]

	def create
		property = @current_user.properties.new(property_params)
		if property.save
			render json: { data: PropertyBlock::PropertySerializer.new(property).serializable_hash, message:'Property created successfully..' }, status: 200
		else
			render json: { errors: property.errors.full_messages, message:"Property creation failed" }, status: 422
		end
	end

	def owner_property 
		properties = @current_user.properties
		render json: { data: PropertyBlock::PropertySerializer.new(properties).serializable_hash, message:'Your property list' }, status: 200
	end

	def index
		properties = PropertyBlock::Property.where.not(user_id: @current_user.id, status: 0)
		render json: { data: PropertyBlock::PropertySerializer.new(properties).serializable_hash, message:'List of properties' }, status: 200
	end

	def search_avail_property
			bookings =  BookingBlock::Booking.where(['(from_date, to_date) OVERLAPS (?, ?)', params[:from_date], params[:to_date]])
			properties = PropertyBlock::Property.where.not(id:(bookings.pluck(:property_id).uniq)).where.not(user_id: @current_user.id).where.not(status:0)
			render json: { data: PropertyBlock::PropertySerializer.new(properties).serializable_hash, message: 'Available property'}, status: 200
	end

	def show
		property = PropertyBlock::Property.where.not(user_id: @current_user.id).find(params[:id])
		render json: { data: PropertyBlock::PropertySerializer.new(property).serializable_hash, message:'Property data' }, status: 200
	end

	def update
		if @property.update(property_params)
			render json: { data: PropertyBlock::PropertySerializer.new(@property).serializable_hash, message:'Property updated successfully' }, status: 200
		else
			render json: { errors: @property.errors.full_messages }, status: 422
		end
	end

	def destroy
		@property.destroy if @property
		render json: { message: "Property deleted successfully..." }, staus: 200
	end

 private 

 def property_params
 	params.require(:property).permit(:property_name, :cost_per_day, :location, :no_of_days)
 end

  def set_property
 		@property = @current_user.properties.find(params[:property_id])
  end
end
