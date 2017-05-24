every :day, at: "1:00 am" do
  rake "sendemail:send_email_deadline", environment: "development"
end
