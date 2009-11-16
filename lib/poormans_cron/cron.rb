module PoormansCron
  class Cron < ActiveRecord::Base
    set_table_name "poormans_crons"

    class << self
      def perform_expired_crons
        self.transaction do
          now = Time.new
          expired_crons(now).each do |cron|
            cron.update_attribute(:performed_at, now)
            cron.perform
          end
        end
      end

      def expired_crons(time)
        find(:all).select do |cron|
          cron.performed_at.nil? || time > (cron.performed_at + cron.interval)
        end
      end

      def jobs
        @jobs ||= Hash.new([])
      end

      def register_job(name, &block)
        jobs[name.to_s] << block
      end

      def perform
        perform_expired_crons
      end
    end

    def perform
      self.class.jobs[name].each do |job|
        job.call
      end
    end
  end
end
