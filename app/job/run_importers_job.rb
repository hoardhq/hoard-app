class RunImportersJob < ActiveJob::Base

  include ActionView::Helpers::DateHelper

  def perform
    Importer.where(active: true).each do |importer|
      print "##{importer.id.to_s.ljust 8}"
      print "#{importer.provider} > #{importer.stream.slug}".ljust 48
      if should_run? importer
        if importer.provider == 'logentries'
          Import::LogEntriesJob.perform_later(importer)
        end
      else
        print "  #{time_ago_in_words Time.now - (minutes_remaining(importer) * 60)} to go"
      end
      puts ""
    end
  end

  private

  def current_minute
    @current_minute ||= Time.now.to_i - Time.now.to_i % 60
  end

  def should_run?(importer)
    minutes_remaining(importer) === 0
  end

  def minutes_remaining(importer)
    return 0 if current_minute % importer.schedule === 0
    (importer.schedule - (current_minute % importer.schedule)) / 60
  end

end
