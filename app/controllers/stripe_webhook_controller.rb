class StripeWebhookController < ApplicationController

	def create
	  payload = request.body.read
	  sig_header = request.env['HTTP_STRIPE_SIGNATURE']
	  event = nil

	  begin
	    event = Stripe::Webhook.construct_event(
	      payload, sig_header, endpoint_secret
	    )
	  rescue JSON::ParserError => e
	    # Invalid payload
	    puts "Error parsing payload: #{e.message}"
	    status 400
	    return
	  rescue Stripe::SignatureVerificationError => e
	    # Invalid signature
	    puts "Error verifying webhook signature: #{e.message}"
	    status 400
	    return
	  end

	  # Handle the event
	  case event.type
	  when 'payment_intent.succeeded'
	    payment_intent = event.data.object # contains a Stripe::PaymentIntent
	    render json: { message: 'PaymentIntent was successful!'}
	  when 'payment_method.attached'
	    payment_method = event.data.object # contains a Stripe::PaymentMethod
	    puts 'PaymentMethod was attached to a Customer!'
	  # ... handle other event types
	  else
	    puts "Unhandled event type: #{event.type}"
	  end

	  status 200
	end
end
