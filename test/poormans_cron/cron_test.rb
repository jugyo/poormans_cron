require 'test_helper'

class CronTest < ActiveSupport::TestCase
  context 'a cron is exists' do
    setup do
      PoormansCron::Cron.delete_all
      @cron = PoormansCron::Cron.create!(:name => 'foo', :interval => 60)
      @now = Time.now
      stub(Time).now { @now }
    end

    context 'performed_at is nil' do
      setup do
        @cron.update_attribute(:performed_at, nil)
      end

      should 'get expired_crons' do
        assert_equal 1, PoormansCron::Cron.expired_crons(@now).size
      end

      should 'called perform' do
        mock(PoormansCron::Cron).expired_crons.with_any_args.times(1) { [@cron] }
        mock(@cron).perform.times(1) {}
        PoormansCron::Cron.perform
      end

      context 'a job was registered' do
        setup do
          @block = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block)
          stub(Thread).start.with_any_args { |block| block.call }
        end

        should 'registered job' do
          assert PoormansCron::Cron.jobs[:foo].include?(@block)
        end

        should 'called perform' do
          mock(@block).call.times(1) {}
          PoormansCron::Cron.perform
        end
      end

      context 'jobs was registered' do
        setup do
          @block1 = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block1)
          @block2 = lambda {}
          PoormansCron::Cron.register_job(:foo, &@block2)
        end

        should 'called perform' do
          mock(@block1).call.times(1) {}
          mock(@block2).call.times(1) {}
          PoormansCron::Cron.perform
        end
      end
    end

    context 'performed_at is now' do
      setup do
        @cron.update_attribute(:performed_at, @now)
      end

      should 'get no expired_cron' do
        assert_equal 0, PoormansCron::Cron.expired_crons(@now).size
      end
    end
  end
end
