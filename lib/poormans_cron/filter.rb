module PoormansCron
  module Filter
    class << self
      def filter(controller)
        Cron.perform_expired_crons
      end
    end
  end
end
