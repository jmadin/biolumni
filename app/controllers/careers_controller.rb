class CareersController < ApplicationController
  before_action :signed_in_user
  before_action :set_career, only: [:show, :edit, :update, :destroy]

  # GET /careers
  # GET /careers.json
  def index
    @careers = Career.all.sort_by { |x| x.records.size }.reverse

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string')
    data_table.new_column('number')

    @careers.each do |i|
      data_table.add_row([i.career_name, Record.where("career_id = ?", i.id).size])
    end

    option = { width: 500, height: 300 }
    @chart_careers = GoogleVisualr::Interactive::PieChart.new(data_table, option)
  end

  # GET /careers/1
  # GET /careers/1.json
  def show
    @records = @career.records.paginate(page: params[:page], per_page: 25)
  end

  # GET /careers/new
  def new
    @career = Career.new
  end

  # GET /careers/1/edit
  def edit
  end

  # POST /careers
  # POST /careers.json
  def create
    @career = Career.new(career_params)

    respond_to do |format|
      if @career.save
        format.html { redirect_to @career, flash: {success: "Career was successfully created." } }
        format.json { render :show, status: :created, location: @career }
      else
        format.html { render :new }
        format.json { render json: @career.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /careers/1
  # PATCH/PUT /careers/1.json
  def update
    respond_to do |format|
      if @career.update(career_params)
        format.html { redirect_to @career, flash: {success: "Career was successfully updated." } }
        format.json { render :show, status: :ok, location: @career }
      else
        format.html { render :edit }
        format.json { render json: @career.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /careers/1
  # DELETE /careers/1.json
  def destroy
    
    begin
      @career.destroy
      flash[:success] = "Career was successfully deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      @career.errors.add(:base, e)
      flash[:danger] = "Career could not be delete. Delete alumni records with this career and try again."
    end
    redirect_to careers_url

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_career
      @career = Career.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def career_params
      params.require(:career).permit(:user_id, :career_name, :career_type, :career_system, :career_notes)
    end
end
