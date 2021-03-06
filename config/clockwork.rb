require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job, time|
    job.constantize.perform_later
  end

  every(1.minute, 'RunImportersJob')
end
