class Notifier < ActionMailer::Base
  
  def account_verification(recipient)
    recipients     recipient['email']
    from           "Nuve <donotreply@lanuve.com>"
    subject        "Welcome to Nuve's Butler"
    body           :recipient => recipient
    content_type   "text/html"
  end
  
end
