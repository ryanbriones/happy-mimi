require "happy-mimi/mailer"

module HappyMimi
  class Mail
    def initialize(parameters = {})
      seperate_parameters(parameters)
      @mailer = HappyMimi::Mailer.new
    end
    
    def set_parameters(parameters = {})
      seperate_parameters(parameters)
    end

    def deliver
      @mailer.send(@mailer_api_method, @parameters)
    end
    
    private
    
    def seperate_parameters(parameters = {})
      parameters.symbolize_keys!
      
      possible_mailer_api_method = parameters.delete(:mailer_api_method)
      @mailer_api_method = possible_mailer_api_method && possible_mailer_api_method.to_sym || :send_transactional_email
      @parameters = parameters
    end
  end
  
  class ActionMailer < ActionMailer::Base
    def message
      @_happy_mimi_message ||= HappyMimi::Mail.new
    end
    
    def mail(parameters = {}, &block)
      @mail_was_called = true
      message.set_parameters(parameters)
      message
    end
  end
end