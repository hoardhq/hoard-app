class ImportersController < ApplicationController

  helper_method :schedule_periods

  def create
    @importer = Importer.new(params.require(:importer).permit(:stream_id, :provider, :endpoint, :schedule))
    if @importer.save
      flash[:success] = "Your importer has been registered"
    else
      flash[:error] = "Error: #{@importer.errors.full_messages.join(', ')}"
    end
    redirect_to importers_path
  end

  def index
    @importers = Importer.all.order(id: :desc)
  end

  def show
  end

  def destroy
    @importer = Importer.find(params[:id])
    @importer.destroy
    flash[:error] = "Your importer has been deleted"
    redirect_to importers_path
  end

  def run
    @importer = Importer.find(params[:id])
    if @importer.provider == 'logentries'
      Import::LogEntriesJob.perform_later(@importer)
    end
    flash[:success] = "Your import has been scheduled"
    redirect_to importers_path
  end

  private

  def schedule_periods
    {
      "Every minute" => 60,
      "Every 5 minutes" => 300,
      "Every 15 minutes" => 900,
      "Every 30 minutes" => 1800,
      "Every hour" => 3600,
      "Every 6 hours" => 21600,
      "Every day" => 86400,
      "Every 7 days" => 604800,
      "Every 30 days" => 2592000,
    }
  end

end
