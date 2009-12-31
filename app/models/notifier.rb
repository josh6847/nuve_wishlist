class Notifier < ActionMailer::Base
  
  def account_verification(recipient)
    recipients     recipient['email']
    from           "donotreply@lanuve.com"
    subject        "Welcome to The Butler by LaNuve"
    body           :recipient => recipient
    content_type   "text/html"
  end
  
end
