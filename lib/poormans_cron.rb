require 'poormans_cron/cron'
require 'poormans_cron/filter'

module PoormansCron
  def self.jobs
    @jobs ||= Hash.new([])
  end

  def self.register_job(name, &block)
    jobs[name.to_s] << block
  end
end

class ActionController::Base
  prepend_before_filter PoormansCron::Filter
end
