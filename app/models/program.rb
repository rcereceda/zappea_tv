class Program
  PROPERTIES = [:channel, :name, :channel_name, :number, :hd, :category, :program, :title, :episode, :description, :time, :duration, :next, :comment, :hashtag, :audience, :total]
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
    new(:channel => json['canal'],
        :name => json['name'],
        :channel_name => json['ncanal'],
        :hd => json['hd'],
        :category => json['category'],
        :program => json['imagen'],
        :title => json['title'],
        :episode => json['episode'],
        :description => json['detail'],
        :time => json['time'],
        :duration => json['duration'],
        :next => json['next'],
        :comment => json['comentario'],
        :hashtag => json['hash'],
        :audience => json['indica'],
        :total => json['total'])
  end
end