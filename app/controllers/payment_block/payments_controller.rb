class PaymentBlock::PaymentsController < ApplicationController

  before_action :authenticate_user
  before_action :check_card_token, only: [:add_card]


  def user_cards 
    cards = Stripe::Customer.list_sources(@current_user.stripe_cust_id,object:"card")
    render json: {card_list: cards , messages: "your card list"}
  end

  def add_card
      card = Stripe::Customer.create_source(@current_user.stripe_cust_id, source: params[:card_token])
      if card
        render json: { card_data: card, messages: "Your card is added successfully" }, status: 200
      else
        render json: { errors: "Your card could not be added" }, status: 422
      end
  end

  private 

  def check_card_token
    unless @current_user.stripe_cust_id.present?
      customer = Stripe::Customer.create(email: @current_user.email, name: @current_user.name)
      @current_user.update_column("stripe_cust_id", customer.id)
    end

    last4_digit =  Stripe::Token.retrieve(params[:card_token])
    if last4_digit.nil?
      return render json: {messages: "Invalid card token" }, status: 422
    elsif Stripe::Customer.list_sources(@current_user.stripe_cust_id, object:"card").data.pluck(:last4).include?(last4_digit&.card&.last4)
      return render json: {messages: "Your card is already added" }, status: 422
    end
  end
  
end
