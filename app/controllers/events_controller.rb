require 'hql/query'

class EventsController < ApplicationController

  def index
    @stream = Stream.find_by(slug: params[:stream])
    @events = Event.all
    @events = @events.where(stream_id: @stream.id) if @stream.present?
    if params[:hql]
      hql_query = HQL::Query.new params[:hql]
      @events = @events.where(hql_query.to_sql)
    end
    @events = @events.order(id: :desc).limit(params[:limit] || 50).offset(params[:offset] || 0)
  end

end
