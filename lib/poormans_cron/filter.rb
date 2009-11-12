module PoormansCron
  module Filter
    class << self
      def filter(controller)
        Thread.start do
          PoormansCron.perform
        end
      end
    end
  end
end
