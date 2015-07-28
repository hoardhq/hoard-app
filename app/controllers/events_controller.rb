require 'hql/query'

class EventsController < ApplicationController

  def index
    @stream = Stream.find_by(slug: params[:stream])
    @events = Event.all
    @events = @events.where(stream_id: @stream.id) if @stream.present?
    if params[:hql].present?
      @hql_query = HQL::Query.new params[:hql]
      @events = @events.where(@hql_query.to_sql) if @hql_query.valid?
    end
    @events = @events.order(id: :desc).limit(params[:limit].presence || 25).offset(params[:offset].presence || 0)
    @columns = @events.map { |row| row.data.keys }.flatten.uniq.sort
  end

end
