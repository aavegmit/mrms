class User < ActiveRecord::Base
   # Include default devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable and :omniauthable
   devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable
   before_create :ensure_authentication_token

   ROLE_ADMIN = 20
   ROLE_DOCTOR = 10
   ROLE_PATIENT = 30

   def ensure_authentication_token
      if session_token.blank?
	 self.session_token = generate_session_token
      end
   end

   def self.getRoleOptions
      [["Doctor", ROLE_DOCTOR]]
   end

   def is_admin?
      self.role == ROLE_ADMIN
   end

   def is_doctor?
      self.role == ROLE_DOCTOR
   end

   def setLastReminderRun
      update_attribute(:last_reminder_run, Date.today)
   end

   def patients
      if is_admin?
	 Patient.all
      elsif is_doctor?
	 Patient.getForDoctor(id)
      end
   end

   private

   def generate_session_token
      loop do
	 token = Devise.friendly_token
	 break token unless User.where(session_token: token).first
      end
   end
end
