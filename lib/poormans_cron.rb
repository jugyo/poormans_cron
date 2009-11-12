require 'poormans_cron/cron'
require 'poormans_cron/filter'

module PoormansCron
  class << self
    def jobs
      @jobs ||= Hash.new([])
    end

    def register_job(name, &block)
      jobs[name.to_s] << block
    end

    def perform
      Cron.perform_expired_crons
    end
  end
end

class ActionController::Base
  around_filter PoormansCron::Filter
end
