class StreamsController < ApplicationController

  def index
    @streams = Stream.all.order(id: :desc)
  end

  def show
    @stream = Stream.find_by(slug: params[:id].downcase)
  end

end
