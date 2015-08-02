class Event < ActiveRecord::Base

  belongs_to :stream

  before_validation :normalize_data

  def normalize_data
    self.data = self.data.delete_if { |key, value| value != false && value.blank? }
    self.uuid = self.data.delete('uuid') if data['uuid']
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
