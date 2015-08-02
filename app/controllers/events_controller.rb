class EventsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :authenticate_user!, only: :create

  before_action :authenticate_api_key!, only: :create
  around_action :track_results, only: :index

  def index
    @stream = Stream.find_by(slug: params[:stream])
    @events = Event.all
    @events = @events.where(stream_id: @stream.id) if @stream.present?
    if params[:hql].present?
      @hql_query = HQL::Query.new params[:hql]
      @hql_query_record = Query.find_by(uuid: @hql_query.uuid)
      if @hql_query_record.blank?
        @hql_query_record = Query.create(
          uuid: @hql_query.uuid,
          raw: @hql_query.canonical,
        )
      end
      @events = @events.where(@hql_query.to_sql) if @hql_query.valid?
    end
    @events = @events.order(id: :desc).limit(params[:limit].presence || 25).offset(params[:offset].presence || 0)
    @columns = @events.map { |row| row.data.keys }.flatten.uniq.sort
  end

  def create
    payloads = JSON.parse request.raw_post
    payloads = [payloads] unless payloads.is_a? Array
    events = []
    payloads.each do |payload|
      events.push Event.create(data: payload)
    end
    render json: events.to_json, status: 201
  end

  private

  def track_results
    time_start = Time.now
    yield
    if @hql_query
      @hql_query_record.query_results.create(
        elapsed: ((Time.now - time_start) * 1000000),
        count: @events.except(:limit, :offset, :order).count,
        stream_id: @stream.try(:id),
      )
    end
  end
end
