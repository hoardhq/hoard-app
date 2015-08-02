require 'rails_helper'

describe Event do

  describe "#normalize_data" do

    it "converts uuid correctly" do
      event = Event.new(data: { 'field' => 'value', 'uuid' => 'test' }, uuid: nil)
      event.valid?
      expect(event.uuid).to eq 'test'
      expect(event.data).to eq('field' => 'value')
    end

    it "removes nil and blank strings from data" do
      data = {
        'stringfield' => 'string',
        'blankfield' => '',
        'nilfield' => nil,
        'falsefield' => false,
        'zerofield' => 0,
      }
      event = Event.new(data: data)
      event.valid?
      expect(event.data).to eq('stringfield' => 'string', 'falsefield' => false, 'zerofield' => 0)
    end

    it "adds to an existing stream" do
      expect(Stream).to receive(:find_by).with(slug: 'test').and_return OpenStruct.new(id: 1)
      expect(Stream).not_to receive(:create!)
      event = Event.new(data: { 'stream' => 'test', 'field' => 'string' }, stream_id: nil)
      event.valid?
      expect(event.stream_id).to eq 1
      expect(event.data).to eq('field' => 'string')
    end

    it "creates a new stream" do
      expect(Stream).to receive(:find_by).with(slug: 'test').and_return nil
      expect(Stream).to receive(:create!).with(slug: 'test', name: 'test').and_return OpenStruct.new(id: 1)
      event = Event.new(data: { 'stream' => 'test', 'field' => 'string' }, stream_id: nil)
      event.valid?
      expect(event.stream_id).to eq 1
      expect(event.data).to eq('field' => 'string')
    end

  end

end
