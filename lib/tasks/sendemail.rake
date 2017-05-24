namespace :sendemail do
  desc "Send email to user with borrowdevice deadline"
  task send_email_deadline: :environment do
    BorrowDevice.send_deline_borrow
  end
end
