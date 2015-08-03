
namespace :import do

  desc "Import Logentries Data"
  task :logentries, [:account_key, :log_set_name, :log_name, :filter, :stream] => :environment do |t, args|
    require 'curb'
    hour_step = 6
    filter_pair = args.filter.present? ? "&filter=#{args.filter}" : ""
    [2015].each do |year|
      (7..8).each do |month|
        puts "#{year}-#{month}"
        (1..31).each do |day|
          puts "  #{year}-#{month}-#{day}"
          hour = 0
          while hour <= 23 do
            hour_start = DateTime.new(year, month, day, hour)
            hour_end = hour_start + hour_step.hours + 1.minute
            hour += hour_step
            print "    From #{hour_start} and #{hour_end}"
            uri = "http://pull.logentries.com/#{args.account_key}/hosts/#{args.log_set_name}/#{args.log_name}/?start=#{hour_start.to_i * 1000}&end=#{hour_end.to_i * 1000}#{filter_pair}"
            http = Curl.get uri
            lines = http.body_str.split("\n")
            event_count = 0
            lines.each do |line|
              payload = JSON.parse(line.match(/\{.*\}/).to_s)
              payload['stream'] = args.stream
              if payload['uuid'].blank? || Event.select(:uuid).find_by(uuid: payload['uuid']).nil?
                event_count += 1
                Event.create(data: payload)
              end
            end
            puts " (#{event_count} / #{lines.count})"
          end
          puts ""
        end
        puts ""
      end
    end
  end

end
