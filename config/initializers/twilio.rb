Rails.application.config.twilio_client = Twilio::REST::Client.new *eval(ENV["TWILIO_#{Rails.env.upcase}"])
Rails.application.config.twilio_number = ENV["TWILIO_#{Rails.env.upcase}_NUMBER"]