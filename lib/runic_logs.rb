require "runic_logs/cronolog"
require "runic_logs/session_request_tagger"
require "runic_logs/version"

module RunicLogs
  
  def self.tag
    SessionRequestTagger.proc
  end
  
  # Hook Rails init process
  class Railtie < Rails::Railtie
    initializer 'runic_logs' do |app|
      SessionRequestTagger.wrap(Rails.logger)
    end
  end

end
