class PatientMailer < ActionMailer::Base
  default from: "from@example.com"

  def daily_reminder(patient_info, vaccines_info, pvs)
     @patient = patient_info
     @vaccines_info = vaccines_info
     @pvs = pvs
     mail :to => patient_info[:email], :from => "some@example.com", :subject => "Reminder"
  end
end
