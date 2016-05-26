class ProgramController < UIViewController

  include Helper

  def initWithProgram(program)
    @program = program
    init
  end
  
  def viewDidLoad
    if Device.screen.height == 480
      height = 372
    else
      height =  460
    end
    
    # back button
    image_up = UIImage.imageNamed 'back_up.png'
    image_down = UIImage.imageNamed 'back_down.png'
    setupLeftBarButton(image_up, image_down)
    
    self.navigationItem.hidesBackButton = true
    
    # tweet button
    image_up = UIImage.imageNamed 'comment_up.png'
    image_down = UIImage.imageNamed 'comment_down.png'
    @tweetButton = setupRightBarButton(image_up, image_down)
    
    # navbar: title view
    @title_view = UIView.alloc.initWithFrame([[0, 0], [220, 44]])
    @title_view.backgroundColor = :clear.uicolor
    
    # navbar: label title
    @title = UILabel.alloc.initWithFrame([[0, 5], [220, 22]])
    @title.text = @program.title
    @title.textAlignment = UITextAlignmentCenter
    @title.font = :bold.uifont(14)
    @title.textColor =  :white.uicolor
    @title.backgroundColor = :clear.uicolor
    # navbar: label time
    time1 = NSDate.dateWithNaturalLanguageString(@program.time)
    time2 = time1 + @program.duration.minutes
    time_string = time1.strftime('%H:%M') + ' - ' + time2.strftime('%H:%M')
    @time = UILabel.alloc.initWithFrame([[0, 20], [220, 22]])
    @time.text = time_string
    @time.textAlignment = UITextAlignmentCenter
    @time.font = :bold.uifont(12)
    @time.textColor =  :white.uicolor
    @time.backgroundColor = :clear.uicolor
    
    # navbar: assign labels to title view
    @title_view.addSubview(@title)
    @title_view.addSubview(@time)
    self.navigationItem.titleView = @title_view
    
    # toolbar
    @toolbar = UIToolbar.alloc.initWithFrame [[0, height], [320, 44]]
    @toolbar.tintColor = :gray.uicolor
    self.view.addSubview(@toolbar)
    
    toolbar_items = ['Descripción', 'Twitter']
    @toolbar_menu = UISegmentedControl.alloc.initWithItems(toolbar_items)
    @toolbar_menu.addTarget(
      self, 
      action: :change,
      forControlEvents: UIControlEventValueChanged
    )
    @toolbar_menu.segmentedControlStyle = UISegmentedControlStyleBar
    @toolbar_menu.selectedSegmentIndex = 0
    @toolbar_menu.sizeToFit
    
    toolbar_menu_button = UIBarButtonItem.alloc.initWithCustomView(@toolbar_menu)
    space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemFlexibleSpace,
      target:nil,
      action:nil
    )

    @buttons = [space, toolbar_menu_button, space]
    
    @toolbar.setItems(@buttons, animated:false)
    
    @current = left_view_controller
    self.view.insertSubview(@current.view, atIndex:0)
  end
  
  def handleRightBarButton
    presentWriteView(@program)
  end
  
  def presentAuthorize
    presentOAuthView(self)
  end
  
  def left_view_controller
    self.navigationItem.rightBarButtonItem = nil
    @left_view_controller ||= DetailViewController.alloc.initWithProgram(@program)
  end

  def right_view_controller
    self.navigationItem.rightBarButtonItem = @tweetButton
    @right_view_controller ||= OAuthTableViewController.alloc.initWithProgram(@program)
  end
  
  def change
    # k, we've got our "old" controller, and its view is at remove.view
    remove = @current

    if @current == left_view_controller
      @current = right_view_controller
      @current.delegate ||= self
      @toolbar_menu.selectedSegmentIndex = 1
    else
      @current = left_view_controller
      @toolbar_menu.selectedSegmentIndex = 0
    end

    # now do the actual view code
    remove.view.removeFromSuperview
    self.view.insertSubview(@current.view, atIndex:0)
  end
  
  def handleLeftBarButton
    self.navigationController.popViewControllerAnimated(true)
  end

end