class FeedbackMailer < ActionMailer::Base
  default :to => "faust451@gmail.com, kanicadidi@gmail.com"

  def feedback(msg)
    @msg = msg
    mail(:from => msg.mail,
         :subject => "Feedback from BharatiRU #{msg.topic}")
  end
  
end
