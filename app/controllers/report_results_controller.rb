class ReportResultsController < ApplicationController

  def new
    @report = Report.find(params[:report_id])
    @report_result = @report.report_results.create(status: 'queued')
    RunReportJob.perform_later(@report_result)
    flash[:success] = "Your report has been scheduled"
    redirect_to report_path(@report)
  end

  def show
    @report = Report.find(params[:report_id])
    @report_result = @report.report_results.find(params[:id])
  end

end
