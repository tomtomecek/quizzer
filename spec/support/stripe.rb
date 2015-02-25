require 'stripe'
module Stripe
  module CertificateBlacklist
    def self.check_ssl_cert(uri, ca_file)
      true
    end
  end
end
