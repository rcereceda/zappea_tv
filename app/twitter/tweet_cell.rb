class TweetCell < UITableViewCell
  Margin = 14
  BigFontSize = 14
  TextFontSize = 12
  AvatarWidth = 48

  def initWithReuseIdentifier(identifier)
    if initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: identifier)
      @imageView = UIImageView.alloc.initWithFrame([[10, Margin], [AvatarWidth, AvatarWidth]])
      @imageView.image = UIImage.imageNamed('avatar_place_holder.png')
      @imageView.layer.masksToBounds = true
      @imageView.layer.cornerRadius = 5
      self.addSubview(@imageView)
      
      @label_user = UILabel.alloc.initWithFrame([[@imageView.frame.size.width + 20, Margin], [0, BigFontSize + 2]])
      @label_user.font = :bold.uifont(BigFontSize)
      @label_user.textColor = :black.uicolor
      self.addSubview(@label_user)
      
      @label_name = UILabel.alloc.initWithFrame([[0, Margin + 2], [0, TextFontSize]])
      @label_name.font = :system.uifont(TextFontSize)
      @label_name.textColor = :gray.uicolor
      self.addSubview(@label_name)
      
      @label_time = UILabel.alloc.initWithFrame([[320 - 24 - 10, Margin + 2], [24, TextFontSize]])
      @label_time.font = :system.uifont(TextFontSize)
      @label_time.textColor = :gray.uicolor
      @label_time.textAlignment = UITextAlignmentRight
      self.addSubview(@label_time)
      
      @label_text = UILabel.alloc.initWithFrame([[@imageView.frame.size.width + 20, @label_user.position.y + @label_user.frame.size.height/2 + 5], [320 - Margin - 10 - 5 - @imageView.frame.size.width, 0]])
      @label_text.font = :system.uifont(BigFontSize)
      @label_text.numberOfLines = 0
      @label_text.lineBreakMode = UILineBreakModeWordWrap
      @label_text.textColor = :black.uicolor
      self.addSubview(@label_text)
    end
    self
  end

  def tweet=(tweet)
    time1 = NSDate.dateWithNaturalLanguageString(tweet.created_at)
    time2 = Time.now
    diff = time2.timeIntervalSinceDate(time1) # segundos
    if diff < 0
      since = '0s'
    elsif diff < 60
      since = diff.to_i.to_s + 's'
    elsif diff > 60 && diff < 3600
      since = (diff / 60).to_i.to_s + 'm'
    elsif diff > 3600 && diff < 86400
      since = (diff / 60 / 60).to_i.to_s + 'h'
    else
      since = (diff / 60 / 60 / 24).to_i.to_s + 'd'
    end
    
    # user
    label_user_width = tweet.user.sizeWithFont(:bold.uifont(BigFontSize)).width
    frm = @label_user.frame
    frm.size.width = label_user_width
    @label_user.frame = frm
    @label_user.text = tweet.user
    
    # screen name
    label_name_width = 320 - @label_user.position.x - @label_user.frame.size.width/2 - 10 - 20 - Margin
    label_name_position = 320 - 6.5 - label_name_width - 20 - Margin 
    frm = @label_name.frame
    frm.size.width = label_name_width
    frm.origin.x = label_name_position
    @label_name.frame = frm
    @label_name.text = "@" + tweet.screen_name
    
    # time
    @label_time.text = since
    
    # highlight
    #if @label_text.respondsToSelector('setAttributedText:') 
    #end
    
    # tweet text
    label_text_height = tweet.text.sizeWithFont(UIFont.systemFontOfSize(BigFontSize),
                                              constrainedToSize: CGSizeMake(@label_text.frame.size.width, 20000),
                                              lineBreakMode: UILineBreakModeWordWrap).height
    frm = @label_text.frame
    frm.size.height = label_text_height
    @label_text.frame = frm
    @label_text.text = tweet.text
    
    # avatar
    if tweet.avatar
      @imageView.image = tweet.avatar
      return
    end
    
    if Device.retina?
      profile_image_url = tweet.avatar_url.gsub("normal", "bigger")
    else
      profile_image_url = tweet.avatar_url
    end

    @imageView.image = UIImage.imageNamed('avatar_place_holder.png')
    Dispatch::Queue.concurrent.async do
      profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(profile_image_url))
      if profile_image_data
        tweet.avatar = UIImage.alloc.initWithData(profile_image_data)
        Dispatch::Queue.main.sync do
          @imageView.image = tweet.avatar
        end
      end
    end
  end

  class << self
    def heightForCellWithTweet(tweet)
      @detailLabelOffsetY ||= BigFontSize + 2 * Margin

      appWidth = UIScreen.mainScreen.applicationFrame.size.width
      labelWidth = 320 - Margin - 10 - 5 - AvatarWidth
      constraint = CGSizeMake(labelWidth, 20000)
      
      detailLabelHeight = tweet.text.sizeWithFont(UIFont.systemFontOfSize(BigFontSize),
                                                constrainedToSize: constraint,
                                                lineBreakMode: UILineBreakModeWordWrap).height

      
      [44 + 2 * Margin, detailLabelHeight + @detailLabelOffsetY].max
    end
  end
end