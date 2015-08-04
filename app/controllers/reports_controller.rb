class ReportsController < ApplicationController

  def new
  end

  def create
    @report = Report.create(create_params)
    redirect_to report_path(@report)
  end

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
  end

  private

  def create_params
    params.require(:report).permit(
      :name,
      :filter,
      :group,
      :function,
      :stream_id,
    )
  end
end
