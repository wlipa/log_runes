require "log_runes/cronolog"
require "log_runes/session_request_tagger"
require "log_runes/version"

module LogRunes
  
  def self.tag
    SessionRequestTagger.proc
  end
  
  # Hook Rails init process
  class Railtie < Rails::Railtie
    initializer 'log_runes' do |app|

      SessionRequestTagger.wrap(Rails.logger)

      # Keep requests separated when deployed for sanity's sake
      unless Rails.env.development?
        ActiveSupport::Notifications.subscribe('process_action.action_controller') do |_|
          Rails.logger.info "\n\n"
        end
      end

    end
  end
  
end
