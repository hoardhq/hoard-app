class SettingsController < ApplicationController

  def index
    @api_keys = ApiKey.all.order(id: :desc)
  end

end
