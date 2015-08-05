class ReportResult < ActiveRecord::Base

  belongs_to :report

  validates :status, inclusion: { in: %w(queued running complete) }

  def complete?
    status === 'complete'
  end

end
