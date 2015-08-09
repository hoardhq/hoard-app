require 'rails_helper'

describe EventsController do

  describe "#create" do
    let(:payload) { '{"stream":"test","data":{"key":"value"}}' }
    subject { post :create, payload }
    it "passes the full payload to ConvertPayloadToEvents" do
      expect(controller).to receive(:authenticate_api_key!).and_return true
      context = OpenStruct.new(events: ['event #1'])
      expect(ConvertPayloadToEvents).to receive(:call).with(payload: payload).and_return context
      subject
      expect(response.body).to eq ['event #1'].to_json
      expect(response.status).to eq 201
    end
  end

end
