require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      context "with accepted card" do
        let(:token) { tokenizer("4242424242424242") }  

        it "makes successfull charge" do
          response = StripeWrapper::Charge.create(
            amount: 1999,
            card_token: token
          )
          expect(response).to be_successful
        end
      end

      context "with declined card" do
        let(:token) { tokenizer("4000000000000002") }        

        it "does not make successfull charge" do
          response = StripeWrapper::Charge.create(
            amount: 1999,
            card_token: token
          )
          expect(response).not_to be_successful
          expect(response.error_message).to eq "Your card was declined."
        end
      end
    end
  end
end

def tokenizer(card_number)
  Stripe::Token.create(
    card: {
      number: card_number,
      cvc: "314",
      exp_month: 12,
      exp_year: Time.now.year + 2
    },
  ).id
end
