module Twitter

  include Helper
  include Constant  

  def fetchTweet(text, &block)
    keychain = getKeychain.fetch
    if keychain['oauth_token'] == nil || keychain['oauth_token_secret'] == nil
      return
    end

    @items ||= []
    @req = OAuth::Request.new(
      consumer_key: CONSUMER_KEY,
      consumer_secret: CONSUMER_SECRET,
      access_token: keychain['oauth_token'], 
      access_token_secret: keychain['oauth_token_secret'],
    )
    
    if @since_id
      params = {q: text, include_entities: '0', lang: 'es', since_id: @since_id}
    else
      if @program.total > 20
        @count = 20
      else
        @count = @program.total
      end
      params = {q: text, include_entities: '0', lang: 'es', count: @count}
    end

    @req.get("https://api.twitter.com/1.1/search/tweets.json",
              params) do |res|
      unless res.ok?
        return
      end

      error = Pointer.new(:object)
      
      json = BubbleWrap::JSON.parse(res.body)
                                                    
      unless json
        raise error[0]
      end
      
      unless json['statuses'].empty?
        @since_id = json['statuses'][0]["id_str"]
        @items = json['statuses'].map { |data| Tweet.from_json(data) } + @items
      end
      
      block.call(res)
    end
  end
end

