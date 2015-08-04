namespace :reports do

   desc "Run a report"
   task :run, [:id] => :environment do |t, args|
     RunReportJob.perform_now(Report.find(args.id))
   end

end
