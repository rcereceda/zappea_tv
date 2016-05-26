class DetailViewController < UIViewController

  def initWithProgram(program)
    @program = program
    init
  end

  def viewDidLoad
    if Device.screen.height == 480
      height = 460
    else
      height = 548
    end
    
    self.view.frame = [[0, 0], [320, height]]
    
    self.view.backgroundColor = :white.uicolor
    
    scroll_frame = self.view.frame
    scroll_frame.origin.y = 0
    @scroll = UIScrollView.alloc.initWithFrame scroll_frame
    @scroll.scrollEnabled = true
    @scroll.delegate
    
    # box
    @box = UIView.alloc.initWithFrame([[9, 9], [302, 119]])
    @box.backgroundColor = 0xF5F5F5.uicolor
    @box.layer.borderWidth = 1
    @box.layer.borderColor = :lightgray.uicolor.CGColor
    
    # program image
    @program_image = UIImageView.alloc.initWithFrame([[10, 10], [200, 112]])
    image_url = @program.program
    
    @program_image.image = UIImage.imageNamed('default-program-hd.png')
    if image_url
      BW::HTTP.get(image_url) do |response|
        if response.ok?
          @program_image.image = UIImage.alloc.initWithData(response.body)
        end
      end
    end
    
    # channel box
    @channel_box = UIView.alloc.initWithFrame([[10, 86], [50, 36]])
    @channel_box.backgroundColor = :gray.uicolor(0.85)
    
    # channel image
    @channel_image = UIImageView.alloc.initWithFrame([[10, 86], [50, 36]])
    @channel_image.image = UIImage.imageNamed(@program.channel.to_s + '.png')
    
    # bar
    @bar = UIView.alloc.initWithFrame([[10, 122], [200, 5]])
    @bar.backgroundColor = 0xCBD0D9.uicolor
    
    # progress image
    @progress_image = UIView.alloc.initWithFrame([[10, 122], [0, 5]])
    @progress_image.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('progress'))
    # progress image limit
    @progress_end_image = UIView.alloc.initWithFrame([[10, 122], [1, 5]])
    @progress_end_image.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('progress_limit'))
    
    #calculo de tiempo transcurrido
    time1 = NSDate.dateWithNaturalLanguageString(@program.time)
    time2 = Time.now
    time3 = time1 + @program.duration.minutes
    diff = time2.timeIntervalSinceDate(time1) / 60
    if diff < 0
      progress = 0
    elsif diff > @program.duration
      progress = 200
    else
      progress = diff / @program.duration * 200
    end
    #actualizar progress bar
    #if evita error cuando progress_image es null
    if @progress_image
      frm = @progress_image.frame
      frm.size.width = progress
      @progress_image.frame = frm
    end
    if @progress_end_image
      pos = @progress_end_image.position
      pos.x = 10 + progress
      @progress_end_image.position = pos
    end
    
    # formatear twitter si audiencia o total es > 0
    if @program.total > 9999
      total = @program.total / 1000
      total = total.to_s + 'K'
    else
      total = @program.total.to_s
    end
    if @program.audience > 9999
      audience = @program.audience / 1000
      audience = audience.to_s + 'K'
    else
      audience = @program.audience.to_s
    end
    
    # label tpm
    @label_tpm = UILabel.alloc.initWithFrame([[215, 15], [80, 20]])
    @label_tpm.text = 'TUITS X MINUTO'
    @label_tpm.font = :bold.uifont(8)
    @label_tpm.textColor =  :gray.uicolor
    @label_tpm.backgroundColor = :clear.uicolor
    @label_tpm.textAlignment = UITextAlignmentLeft
    
    # label tpm
    @audience = UILabel.alloc.initWithFrame([[220, 35], [80, 30]])
    @audience.text = audience
    @audience.font = :bold.uifont(30)
    @audience.textColor =  0x00ADE8.uicolor
    @audience.backgroundColor = :clear.uicolor
    @audience.textAlignment = UITextAlignmentRight
    
    # label total
    @label_total = UILabel.alloc.initWithFrame([[215, 72], [80, 20]])
    @label_total.text = 'TOTAL'
    @label_total.font = :bold.uifont(8)
    @label_total.textColor =  :gray.uicolor
    @label_total.backgroundColor = :clear.uicolor
    @label_total.textAlignment = UITextAlignmentLeft
    
     # label total
    @total = UILabel.alloc.initWithFrame([[220, 92], [80, 30]])
    @total.text = total
    @total.font = :bold.uifont(30)
    @total.textColor =  0x00ADE8.uicolor
    @total.backgroundColor = :clear.uicolor
    @total.textAlignment = UITextAlignmentRight
    
    time_string = time1.strftime('%H:%M') + ' - ' + time3.strftime('%H:%M')
    
    # label title big
    @title_big = UILabel.alloc.initWithFrame([[10, @progress_image.position.y + @progress_image.frame.size.height/2 + 10], [300, 0]])
    @title_big.text = @program.title
    @title_big.textAlignment = UITextAlignmentLeft
    @title_big.font = :system.uifont(18)
    @title_big.textColor = :black.uicolor
    @title_big.backgroundColor = :clear.uicolor
    @title_big.lineBreakMode = UILineBreakModeTailTruncation
    @title_big.numberOfLines = 2
    @title_big.sizeToFit
    
    # label channel alias
    if @program.channel_name
      channel_name = @program.channel_name
    else
      channel_name = @program.name
    end
    
    @channel_alias = UILabel.alloc.initWithFrame([[10, @title_big.position.y + @title_big.frame.size.height/2 + 5], [300, 0]])
    @channel_alias.text = time_string  + ' | ' + channel_name
    ##@channel_alias.text = @program.name  + ' | Canal ' + @program.number
    @channel_alias.textAlignment = UITextAlignmentLeft
    @channel_alias.font = :system.uifont(13)
    @channel_alias.textColor =  :darkgray.uicolor
    @channel_alias.backgroundColor = :clear.uicolor
    @channel_alias.sizeToFit
    
    # episode title
    if @program.episode
      @episode = UILabel.alloc.initWithFrame([[10, @channel_alias.position.y + @channel_alias.frame.size.height/2 + 5], [300, 0]])
      @episode.text = @program.episode
      @episode.textAlignment = UITextAlignmentLeft
      @episode.font = :system.uifont(14)
      @episode.textColor =  :black.uicolor
      @episode.backgroundColor = :clear.uicolor
      @episode.lineBreakMode = UILineBreakModeTailTruncation
      @episode.numberOfLines = 2
      @episode.sizeToFit
      desc_position = @episode.position.y + @episode.frame.size.height/2 + 5
    else
      desc_position = @channel_alias.position.y + @channel_alias.frame.size.height/2 + 5
    end
    
    # label description
    if @program.description
      if @program.description.include? 'width='
        @program.description = ''
      end
    end
    
    @description = UILabel.alloc.initWithFrame([[10, desc_position], [300, 0]])
    @description.text = @program.description
    @description.textAlignment = UITextAlignmentLeft
    @description.font = :system.uifont(13)
    @description.textColor = :darkgray.uicolor
    @description.backgroundColor = :clear.uicolor
    @description.numberOfLines = 0
    @description.sizeToFit
    
    # next box
    @box_next = UIView.alloc.initWithFrame([[-1, @description.position.y + @description.frame.size.height/2 + 15], [322, 10]])
    @box_next.backgroundColor = 0xF0F0F0.uicolor
    @box_next.layer.masksToBounds = true
    @box_next.layer.borderWidth = 1
    @box_next.layer.borderColor = 0xCBD0D9.uicolor.CGColor
    
    # label next
    @label_next = UILabel.alloc.initWithFrame([[10, @box_next.position.y + @box_next.frame.size.height/2 + 15], [300, 0]])
    @label_next.text = 'A CONTINUACIÓN'
    @label_next.textAlignment = UITextAlignmentLeft
    @label_next.font = :system.uifont(16)
    @label_next.textColor = :darkgray.uicolor
    @label_next.backgroundColor = :clear.uicolor
    @label_next.sizeToFit
    
    # next programs table
    @table = UITableView.alloc.initWithFrame([[10, @label_next.position.y + @label_next.frame.size.height/2 + 5], [300, 100]], style: UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table.separatorStyle = UITableViewCellSeparatorStyleNone
    @table.scrollEnabled = false
    
    @table.dataSource = self
    @table.delegate = self
    
    # armar scroll view
    if @program.next
      @scroll.contentSize = CGSizeMake(scroll_frame.size.width, @table.position.y + @table.frame.size.height/2 + 44)
    else
      @scroll.contentSize = CGSizeMake(scroll_frame.size.width, @description.position.y + @description.frame.size.height/2 + 60 + 44)
    end
    self.view.addSubview(@scroll)
    
    @scroll.addSubview(@box)
    @scroll.addSubview(@program_image)
    @scroll.addSubview(@channel_box)
    @scroll.addSubview(@channel_image)
    @scroll.addSubview(@bar)
    @scroll.addSubview(@progress_image)
    @scroll.addSubview(@progress_end_image)
    @scroll.addSubview(@label_tpm)
    @scroll.addSubview(@audience)
    @scroll.addSubview(@label_total)
    @scroll.addSubview(@total)
    @scroll.addSubview(@title_big)
    @scroll.addSubview(@channel_alias)
    @scroll.addSubview(@episode)
    @scroll.addSubview(@description)
    if @program.next
      @scroll.addSubview(@box_next)
      @scroll.addSubview(@label_next)
      @scroll.addSubview(@table)
    end
        
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || 
    UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleSubtitle, 
        reuseIdentifier:@reuseIdentifier)
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.textLabel.textColor = :black.uicolor
    cell.textLabel.font = :system.uifont(14)
    cell.detailTextLabel.textColor = :darkgray.uicolor
    cell.detailTextLabel.font = :system.uifont(13)
    
    next_program = @program.next.split('|')
    time = NSDate.dateWithNaturalLanguageString(next_program[0]).strftime('%H:%M')
    
    cell.imageView.image = UIImage.imageNamed(@program.channel.to_s + '.png')
    cell.imageView.backgroundColor = :gray.uicolor(0.85)
    cell.textLabel.text = next_program[1]
    cell.detailTextLabel.text = time
    
     #cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    
    cell
  end
  
  def tableView(tableView, numberOfRowsInSection: section)
    1
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    50
  end
  
  def close
    self.navigationController.popViewControllerAnimated(true)
  end

end