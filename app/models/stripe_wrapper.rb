module StripeWrapper
  class Charge
    attr_accessor :response, :error_message
    def initialize(options = {})
      self.response = options[:response]
      self.error_message = options[:error_message]
    end

    def self.create(options = {})
      charge = Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        card: options[:card_token]
      )

      new(response: charge)
    rescue Stripe::CardError => error
      new(error_message: error.message)
    end

    def successful?
      response.present?
    end
  end
end
