class PatientsController < ApplicationController
   before_action :set_patient, only: [:show, :edit, :update, :destroy, :vaccinate]
   before_filter :doctorOwnsPatient?, only: [:show, :update, :destroy, :edit, :vaccinate]

   def index
      @patient = Patient.new
      @patients = current_user.patients
   end

   def show
      @vaccines = Vaccine.all
      @maxDoses = Vaccine.maxDoses
      @vaccinesMap = @patient.vaccinesMap
   end

   def edit
   end

   def create
      params[:patient][:doctor_id] = current_user.id unless params[:patient].nil?
      @patient = Patient.new(patient_params)

      if @patient.save
	 redirect_to action: 'index'
      else
	 @patients = Patient.all
	 render action: 'index' 
      end
   end

   def update
      respond_to do |format|
	 if @patient.update(patient_params)
	    format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
	    format.json { head :no_content }
	 else
	    format.html { render action: 'edit' }
	    format.json { render json: @patient.errors, status: :unprocessable_entity }
	 end
      end
   end

   def destroy
      @patient.destroy
      respond_to do |format|
	 format.html { redirect_to patients_url }
	 format.json { head :no_content }
      end
   end

   def vaccinate
      # vaccine_id, doseNumber , date => value
      vaccine_id = params[:vaccine_id].split("-")[1]
      dose_no = params[:dose_no].split("-")[1]
      newDate = params[:value] 

      if newDate == "" 
	 render :json => {:success => false, :new_date => newDate, :html_id => params[:dose_no]}
	 return
      end

      nextDate = @patient.vaccinate(vaccine_id, dose_no, newDate)
      if nextDate
	 render :json => {:success => true, :new_date => newDate, :html_id => params[:dose_no], :next_date => nextDate.to_formatted_s(:rfc822)}
      else
	 render :json => {:success => false, :new_date => newDate, :html_id => params[:dose_no]}
      end
   end

   private
   # Use callbacks to share common setup or constraints between actions.
   def set_patient
      begin
	 @patient = Patient.find(params[:id])
      rescue
	 flash[:alert] = "Unauthorized Request"
	 redirect_to "/"
      end
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def patient_params
      params.require(:patient).permit(:first_name, :last_name, :phone_number, :email, :dob, :doctor_id, :address)
   end

   def doctorOwnsPatient?
      if !@patient.isUnderDoctor(current_user.id)
	 flash[:alert] = "Unauthorized Request"
	 redirect_to :action => 'index'
      end
   end
end
