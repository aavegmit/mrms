class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLE_ADMIN = 20
  ROLE_DOCTOR = 10
  ROLE_PATIENT = 30

  def self.getRoleOptions
     [["Doctor", ROLE_DOCTOR]]
  end

  def is_admin?
     self.role == ROLE_ADMIN
  end

  def is_doctor?
     self.role == ROLE_DOCTOR
  end

end
