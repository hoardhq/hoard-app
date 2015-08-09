class ConvertPayloadToEvents

  include Interactor

  def call
    payloads = parsed_payload
    payloads = [payloads] unless payloads.is_a? Array
    context.events = payloads.map do |payload|
      Event.create(data: payload)
    end
  end

  def parsed_payload
    JSON.parse context.payload
  end

end
