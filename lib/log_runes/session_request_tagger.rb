# encoding: utf-8

module LogRunes
class SessionRequestTagger
  
  # These glyphs should be chosen to maximize visual distinctiveness
  # while being available in OSX terminal fonts.
  
  GLYPHS = %w(
    a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 6 7 8 9 ♓ ÿ
    À Á ♑ Ã Ä Å Æ Ç È ♐ Ê Ë Ì Í Î Ï Ð Ñ Ò Ó ♋ Õ Ö × Ø Ù Ú Û Ü ♎ ♒ ♈
    Ý Þ ß à á â ã ä å æ ç è é ê ë ì í î ï ð ñ ò ó ô õ ö ÷ ø ù ú û ü
    ΐ § ¶ Γ Δ © ® ¥ Θ £ ¿ Λ « » Ξ ± Π ¤ Σ ¢ ¡ Φ ° Ψ Ω Ϊ Ϋ ά έ ή ί ΰ
    α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ ς σ τ υ φ χ ψ ω ϊ ϋ ό ύ ώ ϐ ϑ
    ϒ ϓ ϔ ϕ ϖ ϗ Ϙ ϙ Ϛ ϛ Ϝ ϝ Ϟ ϟ Ϡ ϡ Ϣ ϣ Ϥ ϥ Ϧ ϧ Ϩ ϩ Ϫ ϫ Ϭ ϭ Ϯ ϯ ϰ ϱ
    ♥ Б ♦ ♠ Д ♣ Ж ★ И Й ☉ Л ☇ ☈ ☃ П ☂ ☀ ☄ ☆ Ф ☢ Ц Ч Ш Щ Ъ Ы ☥ Э Ю Я
  )
  

  def self.sign(hex)
    hex.scan(/\h\h/).map do |b|
      GLYPHS[b.to_i(16)]
    end.join
  end
  
  def self.signature(sid, rid)
    "#{sid ? sign(sid[0,8]) : '----'} #{sign(rid[0,4])}"
  end
  
  # At this point in the middleware, we don't have access to the session.
  # A good approximation is the passed-up session id, although it's
  # controlled by the client.  We 'sign' it with a compressed visual
  # representation that doesn't clutter up the log too badly and is still
  # highly likely to be unique when used for debugging expeditions into
  # the log.
  #
  # An abbreviated signature of the request id is added as well, to aid
  # in understanding interleaved log entries.
  
  def self.proc
    Proc.new do |req|
      # Set the tag in the rack environment so it can be picked up by
      # tools like Airbrake.
      req.env['request_tag'] = signature(req.cookies['_session_id'], req.uuid)
    end
  end
  
  def self.wrap(wrapee)
    
    class << wrapee
      
      alias_method :add_original, :add
      
      # Tag each line if multiple are passed in.
      def add(severity, message = nil, progname = nil, &block)
        message = (block_given? ? block.call : progname) if message.nil?
        if message && message.include?("\n")
          message.lines{|l| add_original(severity, l.chomp)}
        else
          add_original(severity, message)
        end
      end
      
    end
    
  end
   
end
end