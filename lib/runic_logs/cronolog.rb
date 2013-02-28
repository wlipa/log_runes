module RunicLogs
  class Cronolog
  
  def self.setup(config, log_base)
    unless File.exists? '/usr/bin/cronolog'
      puts "cronolog missing - reverting to standard logger"
      return
    end
    crono_cmd = "/usr/bin/cronolog -S #{log_base}/#{Rails.env}.log #{log_base}/rot/#{Rails.env}-%Y-%m-%d.log"
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(IO.popen(crono_cmd, "w")))
  end

end
end
