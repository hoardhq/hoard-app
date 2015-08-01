class ApiKeysController < ApplicationController

  def create
    ApiKey.create(params.require(:api_key).permit(:name))
    flash[:success] = "New API Key generated"
    redirect_to settings_path
  end

  def destroy
    api_key = ApiKey.find_by(key: params[:id])
    api_key.destroy
    flash[:success] = "API Key was destroyed"
    redirect_to settings_path
  end

end
