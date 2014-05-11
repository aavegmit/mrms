class PatientsController < ApplicationController
   before_action :set_patient, only: [:show, :edit, :update, :destroy]

   def index
      @patient = Patient.new
      @patients = Patient.all
   end

   def show
      @vaccines = Vaccine.all
      @maxDoses = Vaccine.maxDoses
      @vaccinesMap = @patient.vaccinesMap
   end

   def edit
   end

   def create
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
      # patient_id, vaccine_id, doseNumber , date => value
      patient_id = params[:patient_id]
      vaccine_id = params[:vaccine_id].split("-")[1]
      dose_no = params[:id].split("-")[1]
      newDate = params[:value] 
      patient = Patient.find(patient_id)
      if patient && patient.vaccinate(vaccine_id, dose_no, newDate)
	 render :json => {:success => true, :new_date => newDate, :html_id => params[:id]}
      else
	 render :json => {:success => false}
      end
   end

   private
   # Use callbacks to share common setup or constraints between actions.
   def set_patient
      @patient = Patient.find(params[:id])
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def patient_params
      params.require(:patient).permit(:first_name, :last_name, :phone_number, :email, :dob)
   end
end
