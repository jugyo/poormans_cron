module PoormansCron
  class Cron < ActiveRecord::Base
    set_table_name "poormans_crons"

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
        find_all_by_in_progress(false).select do |cron|
          cron.performed_at.nil? || time > (cron.performed_at + cron.interval)
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
      self.class.jobs[name.to_sym].each do |job|
        job.call
      end
    end
  end
end
