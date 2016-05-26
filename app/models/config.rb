class Config
  PROPERTIES = [:version, :message, :url]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }
  def initialize(hash = {})
    hash.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end
  
  def self.from_json(json)
    new(:version => json['version'],
        :message => json['message'],
        :url => json['url'])
  end
end