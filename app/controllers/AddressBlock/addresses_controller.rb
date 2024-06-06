class AddressBlock::AddressesController < ApplicationController

  def create
    @address = Address.new(address_params)
    if @address.save
      render json: @address, status: :created
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      render json: @address
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  def show
    @address = Address.find(params[:id])
    if @address.reverse_geocode_in_language(params[:language])
      render json: @address
    else
      render json: { error: "Reverse Geocoding failed" }, status: :unprocessable_entity
    end
  end

  def index
  	@addresses = Address.all
  	@addresses.each do |address|
    	address.reverse_geocode_in_language(params[:language])
  	end
  	render json: @addresses
  end

  private

  def address_params
    params.require(:address).permit(:full_address, :latitude, :longitude)
  end
end
