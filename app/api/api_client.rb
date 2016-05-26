class ApiClient
  def self.fetch_programs(&block)
    BW::HTTP.get("http://app.zappea.tv/my.json") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body)
        programs = json.map {|p| Program.from_json(p)}
        block.call(true, programs)
      else
        block.call(false, nil)
      end
    end
  end
  
  def self.load_config(&block)
    BW::HTTP.get("http://app.zappea.tv/config.json") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body)
        config = json.map {|c| Config.from_json(c)}
        block.call(true, config)
      else
        block.call(false, nil)
      end
    end
  end
end