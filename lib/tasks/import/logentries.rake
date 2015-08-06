namespace :import do

  def uuid_from_payload_checksum(payload)
    checksum = Digest::MD5.hexdigest payload.sort_by { |k, v| k }.to_json
    "#{checksum[0..7]}-#{checksum[8..11]}-#{checksum[12..15]}-#{checksum[16..19]}-#{checksum[20..31]}"
  end

  desc "Import Logentries Data"
  task :logentries, [:account_key, :log_set_name, :log_name, :filter, :stream, :days_to_import] => :environment do |t, args|
    args.with_defaults(
      days_to_import: 7,
    )
    require 'curb'
    hour_step = 6
    filter_pair = args.filter.present? ? "&filter=#{args.filter}" : ""
    date = DateTime.now.end_of_day
    date_final = date - args.days_to_import.to_i.days
    while date > date_final
      puts ""
      puts "#{date}"
      hour = 18
      while hour >= 0 do
        hour_start = date.change(hour: hour)
        hour_end = hour_start + hour_step.hours + 1.second
        hour -= hour_step
        print "  #{hour_start.strftime('%H:00')} to #{hour_end.strftime('%H:00')}"
        uri = "http://pull.logentries.com/#{args.account_key}/hosts/#{args.log_set_name}/#{args.log_name}/?start=#{hour_start.to_i * 1000}&end=#{hour_end.to_i * 1000}#{filter_pair}"
        http = Curl.get uri
        lines = http.body_str.split("\n")
        event_count = 0
        print "  #{lines.count.to_s.ljust 6}"
        uuids = {}
        payload = nil
        lines.each do |line|
          payload = JSON.parse(line.match(/\{.*\}/).to_s)
          payload['stream'] = args.stream
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

end
