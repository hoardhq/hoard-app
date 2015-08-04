class ReportResultsController < ApplicationController

  def show
    @report = Report.find(params[:report_id])
    @report_result = @report.report_results.find(params[:id])
  end

end
