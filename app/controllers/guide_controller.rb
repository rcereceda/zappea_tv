class GuideController < UIViewController
  
  include Helper
  include Constant
  include Provider
  
  attr_accessor :category, :sort, :programs, :delegate
  stylesheet  :cell_sheet
  
  def self.build
    @controller ||= alloc.initWithNibName(nil, bundle: nil)
  end

  def layoutDidLoad
    self.category = 0
    self.sort = 0
    # navbar: title image
    titleImage
    
    self.view.backgroundColor = 0xF0F0F0.uicolor
    # menu
    self.navigationItem.leftBarButtonItem = MenuManager.menuButton(self, 'showMenu')
                                                                      
    image_up = UIImage.imageNamed 'refresh_up.png'
    image_down = UIImage.imageNamed 'refresh_down.png'
    button = UIButton.buttonWithType(UIButtonTypeCustom)    
    button.addTarget(self, action: 'refresh', forControlEvents: UIControlEventTouchUpInside)
    button.setImage(image_up, forState:UIControlStateNormal)
    button.setImage(image_down, forState:UIControlStateHighlighted)
    button.frame = CGRectMake(0, 0, 35, 35)
    refreshButton = UIBarButtonItem.alloc.initWithCustomView(button)
    
    image_up = UIImage.imageNamed 'filter_up.png'
    image_down = UIImage.imageNamed 'filter_down.png'
    button = UIButton.buttonWithType(UIButtonTypeCustom)    
    button.addTarget(self, action: 'filter', forControlEvents: UIControlEventTouchUpInside)
    button.setImage(image_up, forState:UIControlStateNormal)
    button.setImage(image_down, forState:UIControlStateHighlighted)
    button.frame = CGRectMake(0, 0, 35, 35)
    searchButton = UIBarButtonItem.alloc.initWithCustomView(button)
    
    self.navigationItem.rightBarButtonItems = [refreshButton, searchButton]
    
    #table
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStylePlain)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table.backgroundColor = 0xF0F0F0.uicolor
    view.addSubview(@table)
    @table.alpha = 0
    
    @table.dataSource = self
    @table.delegate = self
    
    # build  indicator
    buildIndicator
    @indicator.hidesWhenStopped = true
    
    # api programas                                           
    @programs ||= []
    @filter_results = []
    
    refresh
  end
  
  def showMenu
    MenuManager.instance.toggleMenuState
  end
  
  def refresh
    if !@indicator.isAnimating
      # start indicator
      @indicator.startAnimating
      @indicator_box.alpha = 1
      
      ApiClient.fetch_programs do |success, programs|
        # stop indicator
        @indicator.stopAnimating
        @indicator_box.alpha = 0

        if success
          @table.alpha = 1
          @programs = programs
          @programs.each do |p|
            translate(p)
          end
          self.programs = @programs
          p "Received #{@programs.length} programs"
          filter_programs
        else
          App.alert(MESSAGE)
        end
      end
    end
  end
  
  def filter
    filter_controller = FilterProgramsController.alloc.initWithNibName(nil, bundle:nil)
    filter_controller.delegate = self
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(filter_controller),
      animated:true,
      completion: lambda {})
  end
  
  def close_filter
    self.dismissViewControllerAnimated true, completion:nil
  end
  
  def filter_programs
    
    @filter_results = case category
      when 1 then @programs.select { |program| 
        program.name == '13 Cable' ||
        program.name == 'Canal 13' ||
        program.name == 'Canal 13 HD' ||
        program.name == 'UCV' ||
        program.name == 'MEGA' ||
        program.name == 'Chilevisión' ||
        program.name == 'La Red' ||
        program.name == 'TVN' ||
        program.name == 'TeleCanal'
      }
      when 2 then @programs.select { |program| program.category == 'Movie' }
      when 3 then @programs.select { |program| program.category == 'Sports' }
      when 4 then @programs.select { |program| program.category == "Children's" }
      when 5 then @programs.select { |program| program.category == 'Lifestyle' }
      when 6 then @programs.select { |program| program.category == 'News' }
      when 7 then @programs.select { |program| program.category == 'Music' }
      when 8 then @programs.select { |program| program.category == 'Other' }
      when 9 then @programs.select { |program| program.hd == '1' }   
      else @programs
    end
    
    @filter_results = case sort
      ##when 1 then @filter_results.sort_by { |program| program.number.to_i }
      when 1 then @filter_results.sort_by { |program| program.time }.reverse
      else @filter_results
    end
    
    unless appDelegate.hd
      @filter_results = @filter_results.select { |program| program.hd != '1' }
    end
    
    ##@filter_results = @filter_results.select { |program| program.number.nil? == false }
    
    ##p "Showing #{@filter_results.length} programs"
    
    @table.reloadData
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)

    tableView.separatorColor = 0xCBD0D9.uicolor
    if indexPath.row % 2 == 1
      cell = tableView.dequeueReusableCellWithIdentifier(separator_identifier)
      
      if not cell
        cell = UITableViewCell.alloc.initWithStyle( UITableViewCellStyleDefault,
                            reuseIdentifier: separator_identifier)
      end
      cell.contentView.backgroundColor = :clear.uicolor
      cell.userInteractionEnabled = false
    else
      cell = tableView.dequeueReusableCellWithIdentifier(cell_identifier)

      if not cell
        cell = UITableViewCell.alloc.initWithStyle( UITableViewCellStyleDefault,
                            reuseIdentifier: cell_identifier)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
        cell.contentView.backgroundColor = :white.uicolor
        cell.userInteractionEnabled = true

        layout(cell.contentView, :cell) do
          box_image_view = subview(UIView, :box)
          bar_image_view = subview(UIView, :bar)
          progress_image_view = subview(UIView, :progress, tag: PROGRESS_TAG)
          progress_begin_image_view = subview(UIImageView, :progress_limit)
          progress_end_image_view = subview(UIImageView, :progress_limit, tag: PROGRESS_END_TAG)
          channel_image_view = subview(UIImageView, :channel, tag: CHANNEL_TAG)
          hd_view = subview(UILabel, :hd, tag: HD_TAG)
          number_view = subview(UILabel, :number, tag: NUMBER_TAG)
          program_image_view = subview(UIImageView, :program, tag: PROGRAM_TAG)
          title_view = subview(UILabel, :title, tag: TITLE_TAG)
          time_view = subview(UILabel, :time, tag: TIME_TAG)
          audience_view = subview(UILabel, :audience, tag: AUDIENCE_TAG)
          logo_view = subview(UIImageView, :logo, tag: LOGO_TAG)
        end
      else
        channel_image_view = cell.viewWithTag(CHANNEL_TAG)
        hd_view = cell.viewWithTag(HD_TAG)
        number_view = cell.viewWithTag(NUMBER_TAG)
        program_image_view = cell.viewWithTag(PROGRAM_TAG)
        title_view = cell.viewWithTag(TITLE_TAG)
        time_view = cell.viewWithTag(TIME_TAG)
        audience_view = cell.viewWithTag(AUDIENCE_TAG)
        logo_view = cell.viewWithTag(LOGO_TAG)
        progress_image_view = cell.viewWithTag(PROGRESS_TAG)
        progress_end_image_view = cell.viewWithTag(PROGRESS_END_TAG)
        # restablecer ancho de title_view
        frm = title_view.frame
        frm.size.width = 120
        title_view.frame = frm
      end

      indexInModel = indexPath.row / 2;
      program = @filter_results[indexInModel]
      
      if program
        # cálculo de tiempo transcurrido
        time1 = NSDate.dateWithNaturalLanguageString(program.time)
        time2 = Time.now
        time3 = time1 + program.duration.minutes
        diff = time2.timeIntervalSinceDate(time1) / 60
        if diff < 0
          progress = 1
        elsif diff > program.duration
          progress = 100
        else
          progress = diff / program.duration * 100
        end
        # actualizar progress bar
        # if evita error cuando progress_image_view es null
        if progress_image_view
          frm = progress_image_view.frame
          frm.size.width = progress
          progress_image_view.frame = frm
        end
        if progress_end_image_view
          pos = progress_end_image_view.position
          pos.x = 55 + progress - 0.5
          progress_end_image_view.position = pos
        end
        # 1: cargar imagen del programa desde url
        # 2: cache de imagenes (delegate) appDelegate.data
        image_url = program.program
        if appDelegate.data[image_url]
          program_image_view.image = UIImage.imageWithData(appDelegate.data[image_url])
        else
          program_image_view.image = UIImage.imageNamed('default-program.png')
          if image_url
            BW::HTTP.get(image_url) do |response|
              if response.ok?
                appDelegate.data[image_url] = NSData.dataWithData(response.body)
                updateCell = tableView.cellForRowAtIndexPath(indexPath)
                if (updateCell)
                  program_image_view.image = UIImage.imageWithData(appDelegate.data[image_url])
                end
              end
            end
          end
        end
        
        #asignar valores a campos
        channel_image_view.image = UIImage.imageNamed(program.channel.to_s + '.png')
        
        if (program.hd == '1')
            hd_view.text = 'HD'
        else
            hd_view.text = ''
        end
        
        ##number_view.text = program.number
        
        title_view.text = program.title
        title_view.sizeToFit
        time_view.text = time1.strftime('%H:%M') + ' - ' + time3.strftime('%H:%M')
        
        # mostrar twitter si audiencia es > 0
        if program.total > 0
          if program.total > 999
            audience = program.total / 1000
            audience = audience.to_s + 'K'
          else
            audience = program.total.to_s
          end
          audience_view.text = audience
          logo_view.image = UIImage.imageNamed('bird_blue.png')
        else
          audience_view.text = ''
          logo_view.image = nil
        end
        
      end
    end
    
    return cell
  end

  def cell_identifier
    @@cell_identifier ||= 'Cell'
  end
  
  def separator_identifier
    @@separator_identifier ||= 'Separator'
  end

  def tableView(tableView, numberOfRowsInSection: section)
    separators_length = @filter_results.length - 1
    total_rows = @filter_results.length + separators_length
    case section
    when 0
      total_rows
    else
      0
    end
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    if indexPath.row % 2 == 1
      10
    else
      70
    end
  end

  def tableView(tableView, heightForFooterInSection:section)
    return 0.01
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # we could cache these in a hash or something, but that's not necessary
    # right now, I think...
    view_controller = ProgramController.alloc.initWithProgram(@filter_results[indexPath.row/2])
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.parentViewController.pushViewController(view_controller, animated: true)
  end
  
  # Helpers

  def titleImage
    @title_image = UIImageView.alloc.initWithFrame([[0, 0], [120, 25]])
    @title_image.image = UIImage.imageNamed('zappea.png')
    self.navigationItem.titleView = @title_image
  end
  
  def buildIndicator
    # indicator box
    @indicator_box = UIView.alloc.initWithFrame([[120, 150], [80, 100]])
    @indicator_box.backgroundColor = :darkgray.uicolor
    @indicator_box.layer.cornerRadius = 5
    self.view.addSubview(@indicator_box)
    
    # label indicator
    @indicator_label = UILabel.alloc.initWithFrame([[0, 70], [80, 20]])
    @indicator_label.text = 'Cargando'
    @indicator_label.font = :bold.uifont(12)
    @indicator_label.textColor = :white.uicolor
    @indicator_label.backgroundColor = :clear.uicolor
    @indicator_label.textAlignment =  UITextAlignmentCenter
    @indicator_box.addSubview(@indicator_label)
    
    # start indicator
    @indicator = UIActivityIndicatorView.large
    @indicator.frame = [[20, 20], [40, 40]]
    @indicator_box.addSubview(@indicator)
  end
  
end