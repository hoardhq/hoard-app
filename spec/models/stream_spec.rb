require 'rails_helper'

describe Stream do

  describe "#to_param" do
    it do
      model = Stream.new
      expect(model).to receive(:slug).and_return 'sluggy'
      expect(model.to_param).to eq 'sluggy'
    end
  end

end
