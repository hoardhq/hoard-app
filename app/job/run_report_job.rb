class RunReportJob < ActiveJob::Base
  def perform(report)
    time_start = Time.now
    query = Event.filter_by_hql(report.filter)
    query = query.where(stream_id: report.stream_id)
    if report.group.index('||').nil?
      query = query.group("data->>'#{report.group}'")
    else
      query = query.group(report.group.split('||').map(&:strip).map { |field| "data->>'#{field}'" })
    end
    query = query.order('count_all DESC')
    results = query.count
    report.report_results.create(
      results: results,
      count: results.count,
      elapsed: ((Time.now - time_start) * 1000000),
    )
  end
end
