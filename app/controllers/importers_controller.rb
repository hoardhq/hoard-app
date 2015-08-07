class ImportersController < ApplicationController

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

end
