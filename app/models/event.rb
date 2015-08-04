class Event < ActiveRecord::Base

  belongs_to :stream

  before_validation :normalize_data

  def self.filter_by_hql(hql)
    @hql_query = HQL::Query.new hql
    self.where(@hql_query.to_sql) if @hql_query.valid?
  end

  def normalize_data
    self.data = self.data.delete_if { |key, value| value != false && value.blank? }
    self.id = self.data.delete('uuid') if data['uuid']
    if data['stream']
      @stream = Stream.find_by(slug: data['stream'])
      if @stream.nil?
        @stream = Stream.create!(
          slug: data['stream'],
          name: data['stream'],
        )
      end
      data.delete('stream')
      self.stream_id = @stream.id if @stream.present?
    end
  end
end
