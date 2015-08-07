namespace :importers do

  desc "Import Logentries Data"
  task :run => :environment do |t, args|
    RunImportersJob.perform_now
  end

end
