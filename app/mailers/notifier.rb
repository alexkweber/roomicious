class Notifier < ActionMailer::Base
  default from: "Alex Weber <alex.weber@roomicious.com>"

  def email_added(user)
    @app_name = "Roomicious"
    @email = user.email
    mail to: @email, subject: 'Auto-Response: Thank you for signing up'
  end
end
