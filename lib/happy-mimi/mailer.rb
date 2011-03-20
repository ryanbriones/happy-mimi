require "happy-mimi"
require "yaml"

module HappyMimi
  class Mailer    
    def initialize(transaction_id = nil)
      @transaction_id = transaction_id
    end
    
    def self.with_transaction_id(transaction_id)
      self.new(transaction_id)
    end
    
    def send_transactional_email(parameters = {})
      parameters.symbolize_keys!
      
      raise ArgumentError, ":promotion_name parameter required" unless parameters[:promotion_name]
      
      unless parameters[:body].is_a?(String)
        parameters[:body] = parameters[:body].to_yaml
      end
      
      response = HappyMimi.call_api("/mailer", :post, parameters)
      case response
      when Net::HTTPSuccess
        @transaction_id = response.body
      when Net::HTTPClientError
        @last_error =  response.body
      when Net::HTTPServerError
        @last_error = "Something went wrong on the server"
      end
    end
  end
end