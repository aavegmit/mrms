class VaccinesController < ApplicationController
  before_action :set_vaccine, only: [:show, :edit, :update, :destroy]

  def index
    @vaccine = Vaccine.new
    @vaccines = Vaccine.all
  end

  def show
  end

  def edit
  end

  def create
    @vaccine = Vaccine.new(vaccine_params)

    if @vaccine.save
       redirect_to action: 'index'
    else
       @vaccines = Vaccine.all
       render action: 'index'
    end
  end

  def update
    respond_to do |format|
      if @vaccine.update(vaccine_params)
        format.html { redirect_to @vaccine, notice: 'Vaccine was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vaccine.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @vaccine.destroy
    respond_to do |format|
      format.html { redirect_to vaccines_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vaccine
      @vaccine = Vaccine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vaccine_params
      params.require(:vaccine).permit(:name, :no_of_doses, :doses_gaps, :catchup_in_weeks)
    end
end
