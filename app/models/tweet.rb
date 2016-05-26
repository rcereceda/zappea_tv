class Tweet
  attr_accessor :avatar
  
  PROPERTIES = [:avatar_url, :text, :user, :screen_name, :created_at]
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
    new(:avatar_url => json['user']['profile_image_url'],
        :text => json['text'],
        :user => json['user']['name'],
        :screen_name => json['user']['screen_name'],
        :created_at => json['created_at'])
  end
end
