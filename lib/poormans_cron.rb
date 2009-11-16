require 'poormans_cron/cron'
require 'poormans_cron/filter'

class ActionController::Base
  around_filter PoormansCron::Filter
end
