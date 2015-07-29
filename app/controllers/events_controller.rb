class EventsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :create

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

  def create
    payloads = JSON.parse request.raw_post
    unless payloads.is_a? Array
      payloads = [payloads]
    end
    events = []
    payloads.each do |payload|
      stream = Stream.select(:id).find_by(slug: payload.delete('stream'))
      if stream.present?
        payload['stream_id'] = stream.id
        events.push Event.create(payload)
      end
    end
    render json: events.to_json, status: 201
  end

end
