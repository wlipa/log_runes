module LogRunes
class LoggerFactory

  def self.set(config, opts)

    if Rails.env.development? || Rails.env.test?
      # Use a stdout logger to avoid piling up a mostly useless giant log file
      stdout_logger = ActiveSupport::Logger.new(STDOUT)
      config.logger = ActiveSupport::TaggedLogging.new(stdout_logger)
      return
    end
    
    log_base = opts[:dir] || "#{Rails.root}/log"
    log_name = opts[:name] || Rails.env
    l = ActiveSupport::Logger.new("#{log_base}/#{log_name}.log", 'daily')

    config.logger = opts[:not_tagged] ? l : ActiveSupport::TaggedLogging.new(l)

  end


end
end
