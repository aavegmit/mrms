class PatientMailer < ActionMailer::Base
  default from: "from@example.com"

  def daily_reminder(pvs)
     @pvs = pvs
     mail :to => pvs[0][:email], :from => "some@example.com", :subject => "Reminder"
  end
end
