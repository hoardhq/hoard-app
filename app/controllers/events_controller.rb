class EventsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :authenticate_user!, only: :create

  before_action :authenticate_api_key!, only: :create

  def index
    time_start = Time.now
    @stream = Stream.find_by(slug: params[:stream])
    @fields = ActiveRecord::Base.connection.execute("SELECT DISTINCT field FROM (SELECT jsonb_object_keys(data) AS field FROM events) AS subquery").map { |row| row['field'] }
    if @stream.present?
      @events = Event.filter_by_hql(params[:hql]) || Event.all
      @events = @events.where(stream_id: @stream.id) if @stream.present?
      @events = @events.order(created_at: :desc).limit(params[:limit].presence || 25).offset(params[:offset].presence || 0)
      if params[:aggregate] && params[:aggregate][:function].present?
        @events = @events.except(:order, :limit, :offset).group_by_hour(:created_at, range: 7.days.ago..Time.now)
        @events = @events.calculate(params[:aggregate][:function], params[:aggregate][:field].present? ? "(data->>'#{params[:aggregate][:field]}')::integer" : :all)
      end
    end
    @elapsed = Time.now - time_start
  end

  def create
    payloads = JSON.parse request.raw_post
    payloads = [payloads] unless payloads.is_a? Array
    events = payloads.map do |payload|
      Event.create(data: payload)
    end
    render json: events.to_json, status: 201
  end

  private

    end
end
