module PoormansCron
  class Cron < ActiveRecord::Base
    set_table_name "poormans_crons"

    DEFAULT_WAIT_TIME = 60 * 60

    class << self
      def perform
        crons = nil

        self.transaction do
          now = Time.new
          crons = expired_crons(now)
          crons.each do |cron|
            cron.update_attributes(:performed_at => now, :in_progress => true)
          end
        end

        return unless crons

        crons.each do |cron|
          cron.perform
        end
      ensure
        self.transaction do
          crons.each do |cron|
            cron.update_attributes(:in_progress => false)
          end
        end
      end

      def expired_crons(time)
        find(:all, :lock => true).select do |cron|
          unless cron.in_progress
            cron.performed_at.nil? || time > (cron.performed_at + cron.interval)
          else
            (time - cron.performed_at).to_i > (cron.wait_time || DEFAULT_WAIT_TIME)
          end
        end
      end

      def jobs
        @jobs ||= {}
      end

      def register_job(name, &block)
        name = name.to_sym
        jobs[name] = [] unless jobs.key?(name)
        jobs[name] << block
      end
    end

    def perform
      if jobs = self.class.jobs[name.to_sym]
        jobs.each do |job|
          job.call
        end
      end
    end
  end
end
