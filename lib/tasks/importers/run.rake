namespace :importers do

  desc "Import Logentries Data"
  task :run => :environment do |t, args|
    Rails.application.config.active_job.queue_adapter = :inline
    RunImportersJob.perform_now
  end

end
