class PaymentBlock::PaymentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :brand, :country, :exp_month, :exp_year, :last4, :fingerprint, :cvc_check
end
