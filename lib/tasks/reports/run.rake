namespace :reports do

   desc "Run a report"
   task :run, [:id] => :environment do |t, args|
      report = Report.find(args.id)
      report_result = report.report_results.create
      puts "Running report"
      time_start = Time.now
      RunReportJob.perform_now(report_result)
      puts "report generated in #{((Time.now - time_start) * 1000.0).round 2}ms"
   end

end
