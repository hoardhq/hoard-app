class Import::LogEntriesJob < ActiveJob::Base

  def perform(importer)
    hour_step = 2
    date = DateTime.now
    date_final = date - importer.schedule.seconds
    while date > date_final
      puts ""
      puts "#{date}"
      hour = 24 - hour_step
      while hour >= 0 do
        hour_start = date.change(hour: hour)
        hour_end = hour_start + hour_step.hours + 1.second
        return if hour_end <= date_final
        hour -= hour_step
        next if hour_start > DateTime.now
        print "  #{hour_start} to #{hour_end}"
        uri_string = importer.endpoint.gsub('{date:start}', (hour_start.to_i * 1000).to_s).gsub('{date:end}', (hour_end.to_i * 1000).to_s)
        uri = URI.parse(uri_string)
        response = Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Get.new uri
          http.request request
        end
        if response.body.index('{') === 0
          json = JSON.parse(response.body)['']
          if json['response'] == 'error'
            puts "  ERROR: #{json['reason']}"
            next
          end
        end
        lines = response.body.split("\n")
        event_count = 0
        print "  #{lines.count.to_s.ljust 6}"
        uuids = {}
        payload = nil
        lines.each do |line|
          payload = JSON.parse(line.match(/\{.*\}/).to_s)
          payload['stream'] = importer.stream.slug
          payload['uuid'] = uuid_from_payload_checksum(payload)
          uuids[payload['uuid']] = payload
        end
        existing_uuids = Event.select(:id).where(id: uuids.keys).pluck(:id)
        uuids.each do |uuid, payload_data|
          unless existing_uuids.include? uuid
            event_count += 1
            Event.create(data: payload_data)
          end
        end
        print event_count.to_s.ljust 10
        _pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
        print "  #{size / 1024} mb"
        puts ""
      end
      date -= 1.day
    end

  end

  private

  def uuid_from_payload_checksum(payload)
    checksum = Digest::MD5.hexdigest payload.sort_by { |k, v| k }.to_json
    "#{checksum[0..7]}-#{checksum[8..11]}-#{checksum[12..15]}-#{checksum[16..19]}-#{checksum[20..31]}"
  end

end
