module PoormansCron
  module Filter
    class << self
      def filter(controller)
        yield
      ensure
        Thread.start do
          begin
            PoormansCron::Cron.perform
          rescue Exception => e
            puts "#{e}\n#{e.backtrace.join("\n")}"
          end
        end
      end
    end
  end
end
