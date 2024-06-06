module TransactionBlock
	class TransactionsController < ApplicationController

		before_action :authenticate_user, except: [:update_transaction_status]

		before_action :set_booking, only: [:create]
		before_action :set_transaction, only: [:show]

		# def create
		#   transaction = @booking.transactions.new(amount: @booking.total_price)
		#   if transaction.valid?
		#       session = Stripe::Checkout::Session.create(customer: @current_user.stripe_cust_id, amount:(@booking.total_price * 100).to_i, currency:"inr",payment_method_types:["card"],payment_method: params[:card_id],automatic_payment_methods:{enabled:false},confirm:true)
		#       transaction.card_id = payment_intent.payment_method
		#       transaction.save
		#       render json: { transaction_data: transaction, messages: "Your transaction is completed" }, status: 200
		#   else
		#     render json: { messages: "Your transaction failed" }, status: 422
		#   end
		# end


		def create

			return render json: { messages: "Transaction already completed for this booking" }, status: :unprocessable_entity if @booking.transactions.exists?(status: 'paid')
		  transaction = @booking.transactions.new(amount: @booking.total_price/100)
		  
		  price_data = {
		    currency: 'inr',
		    product_data: {
		      name: @booking.property.property_name
		    },
		    unit_amount: (@booking.total_price * 100).to_i
		  }

		  default_expiration_time = (Time.now + 30.minutes).to_i

		  if transaction.valid?
		    # Create a Checkout Session
		    session = Stripe::Checkout::Session.create(
		      customer: @current_user.stripe_cust_id,
		      customer_email: @current_user.email,
		      payment_method_types: [params[:payment_method]],
		      line_items: [{
		        price_data: price_data,
		        quantity: 1
		      }],
		      mode: 'payment',
		      billing_address_collection: 'required',
		      shipping_address_collection: {
		        allowed_countries: [],
		      },
		      success_url: "http://127.0.0.1:3000/transaction_block/update_transaction_status?session_id={CHECKOUT_SESSION_ID}",
		      cancel_url: "http://127.0.0.1:3000/transaction_block/update_transaction_status?session_id={CHECKOUT_SESSION_ID}",
		    	expires_at: default_expiration_time
		    )
		    
		    # Save the session ID to the transaction
		    transaction.session_id = session.id
		    transaction.save
		    render json: { transaction_url: session, messages: "Your transaction is created" }, status: 200
		  else
		    render json: { messages: "Your transaction failed" }, status: 422
		  end
		end

		def update_transaction_status
			debugger
			session = Stripe::Checkout::Session.retrieve(params[:session_id])
			transaction = TransactionBlock::Transaction.find_by(session_id: params[:session_id])
			transaction.update(status: session.payment_status, payment_id: session.payment_intent)
			render json: { transaction: transaction,messages: "your payment is #{session.status}"}
		end


		def index
			transaction = TransactionBlock::Transaction.joins(:booking).where("booking_block_bookings.user_id=?",@current_user.id) 
			transaction = transaction.where(status: params[:status]) if ["completed", "canceled"].include?(params[:status])
			render json: { data: transaction, messages: "Your trasaction list"}, status: 200
		end

		def show 
			render json: {data: @transaction, messages: "Your transaction data" }, status: 200
		end

		private

		def set_booking

			@booking = @current_user.bookings.where(status:[0,1]).find(params[:booking_id])
				status = @booking.transactions.pluck(:status)
			if status.include?("completed")
				return render json: { errors: "This booking Transaction is already completed"}, status:422
			elsif @booking.total_price != params[:amount].to_d
				return render json: { errors: "Your amount must be equal to booking amount"}, status:422
			end
		end

		def set_transaction
			@transaction = TransactionBlock::Transaction.find(params[:transaction_id])
			if @transaction.booking.user_id != @current_user.id
				return render json: { errors: "Your not authorized to see this transaction" }, status: 401
			end
		end
	end
end
