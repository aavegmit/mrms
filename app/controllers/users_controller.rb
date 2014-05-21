class UsersController < Devise::RegistrationsController

   def new
      @role_options = User.getRoleOptions()
      super
   end

   def create
      super
   end

   def update
      super
   end
end
