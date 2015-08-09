class DashboardController < ApplicationController

  def index
    @streams = Stream.all.order(name: :asc)
  end

end
