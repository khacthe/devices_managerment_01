class UserMailer < ApplicationMailer

  def send_email_deadline_to_user user
    @user = user
    mail to: user.email, subject: t("mailer.title_deadline")
  end
end
