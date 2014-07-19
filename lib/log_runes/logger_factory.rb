module LogRunes
class LoggerFactory
  
  
  def self.set(config, opts)

    if Rails.env.development? || Rails.env.test?
      # Use a stdout logger to avoid piling up a mostly useless giant log file
      config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
      return
    end
    
    return if opts[:no_cronolog]
    cronolog_path = opts[:cronolog_path] || '/usr/bin/cronolog'
    unless File.exists? cronolog_path
      puts "cronolog missing - reverting to standard logger"
      return
    end
    
    log_base = opts[:dir] || "#{Rails.root}/log"
    log_name = opts[:name] || Rails.env
    crono_cmd = "#{cronolog_path} -S #{log_base}/#{log_name}.log #{log_base}/rot/#{log_name}-%Y-%m-%d.log"
    l = Logger.new(IO.popen(crono_cmd, "w"))
    config.logger = opts[:not_tagged] ? l : ActiveSupport::TaggedLogging.new(l)

  end


end
end
