Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  namespace :user_block do 
    post 'sign_up', to: 'users#sign_up'
    post 'sign_in', to: 'users#sign_in'
    get 'index', to: 'users#index'
  end

  get 'auth/github/callback', to: 'user_block/users#login_with_github'

  namespace :property_block do 
    resources :properties
    put 'property/:property_id', to: "properties#update"
    delete 'property/:property_id', to: "properties#destroy"
    get 'owner_property', to: 'properties#owner_property'
    get 'search_avail_property', to: 'properties#search_avail_property'
    resources :properties

  end

  namespace :booking_block do
    resources :bookings
    post 'accept_or_reject_booking',to: 'bookings#accept_or_reject_booking'
    get 'cancel_booking', to: 'bookings#cancel_booking'
    get 'user_booking', to: 'bookings#user_booking'
    get 'owner_booking', to: 'bookings#owner_booking'
  end

  namespace :transaction_block do 
    get 'show/:transaction_id', to: 'transactions#show'
    resources :transactions
    get 'update_transaction_status', to: 'transactions#update_transaction_status'
  end

  namespace :amount_block do 
    resources :refund_amounts
  end

  namespace :payment_block do 
    resources :payments
    post 'add_card', to: 'payments#add_card'
    get 'user_cards', to: 'payments#add_cards'

  end

  namespace :faq_block do 
    resources :faqs
    get 'question_list', to: 'faqs#question_list'
    get 'search', to: 'faqs#search'
  end

    post '/my/webhook/url', to: 'stripe_webhook#create'

    namespace :address_block do
        resources :addresses
    end
end
