module AnswerExceptions
  class AnswerException < StandardError
    attr_accessor :message
    def initialize(options = {})
      self.message = options[:message]
    end
  end
end
