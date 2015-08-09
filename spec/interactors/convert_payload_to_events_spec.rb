require 'rails_helper'

describe ConvertPayloadToEvents do

  describe "#call" do
    context "single event json payload" do
      let(:payload) { '{"stream":"test","data":{"key":"value"}}' }
      let(:payload_hashed) { { 'stream' => 'test', 'data' => {'key' => 'value'} } }
      let(:interactor) { described_class.new(payload:payload) }
      subject { interactor.call }
      it do
        expect(interactor).to receive(:parsed_payload).and_return payload_hashed
        expect(Event).to receive(:create).with(data: payload_hashed).and_return 'event #1'
        subject
        expect(interactor.context.events).to eq ['event #1']
      end
    end
    context "multi event json payload" do
      let(:payload) { '[{"stream":"test","data":{"key":"value"}},{"stream":"test2","data":{"key2":"value2"}}]' }
      let(:payload_hashed) { [{ 'stream' => 'test', 'data' => {'key' => 'value'} }, { 'stream' => 'test2', 'data' => {'key2' => 'value2'} }] }
      let(:interactor) { described_class.new(payload:payload) }
      subject { interactor.call }
      it do
        expect(interactor).to receive(:parsed_payload).and_return payload_hashed
        expect(Event).to receive(:create).with(data: payload_hashed[0]).and_return 'event #1'
        expect(Event).to receive(:create).with(data: payload_hashed[1]).and_return 'event #2'
        subject
        expect(interactor.context.events).to eq ['event #1', 'event #2']
      end
    end
  end

  describe "#parsed_payload" do
    context "json data" do
      subject { ConvertPayloadToEvents.new(payload: 'json payload').parsed_payload }
      it do
        expect(JSON).to receive(:parse).with('json payload')
        subject
      end
    end
  end

end
