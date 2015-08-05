class RunReportJob < ActiveJob::Base
  def perform(report_result)
    report_result.update(status: 'running')
    report = report_result.report
    time_start = Time.now
    query = report.filter.present? ? Event.filter_by_hql(report.filter) : Event.all
    query = query.where(stream_id: report.stream_id) if report.stream_id.present?
    if report.group.index('||').nil?
      query = query.group("data->>'#{report.group}'")
    else
      query = query.group(report.group.split('||').map(&:strip).map { |field| "data->>'#{field}'" })
    end
    query = query.order('count_all DESC')
    results = query.count
    report_result.update(
      results: results,
      count: results.count,
      elapsed: ((Time.now - time_start) * 1000000),
      status: 'complete',
    )
  end
end
