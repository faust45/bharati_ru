class FeedbackMailer < ActionMailer::Base
  default :to => "faust451@gmail.com"

  def feedback(msg)
    mail(:from => msg.mail,
         :msg => msg,
         :subject => "Feedback from BharatiRU #{msg.topic}")
  end
  
end
