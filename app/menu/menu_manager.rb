class MenuManager
  attr_accessor :navigationController, :menu, :visible
   
  SHADOW_WIDTH = 10.0
     
  @@instance = nil
   
  #Used to simply maintain state of sidemenu
  @@visible = false
   
  def self.instance
    return @@instance unless @@instance.nil?
    
    @navigationController = UINavigationController.alloc.initWithRootViewController(GuideController.build)
    
    # custom navigation background image
    image = UIImage.imageNamed('bar.png') 
    @navigationController.navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetricsDefault)
    
    @menu = SideMenuController.build
     
    @@instance = MenuManager.new(@navigationController, @menu)
     
    @@instance
  end
   
  def initialize(navigationController, menuController)
    @navigationController = navigationController
    @menu = menuController
  end
     
  def setupMenuView
    self.navigationController.view.superview.insertSubview(self.menu.view, belowSubview: self.navigationController.view)
     
    pathRect = self.navigationController.view.bounds
    pathRect.size.width = SHADOW_WIDTH
    self.navigationController.view.layer.shadowPath = UIBezierPath.bezierPathWithRect(pathRect).CGPath
     
    self.navigationController.view.layer.shadowOpacity = 0.75
    self.navigationController.view.layer.shadowRadius = SHADOW_WIDTH
    self.navigationController.view.layer.shadowColor = UIColor.blackColor.CGColor
  end
 
  def toggleMenuState
    destination = self.navigationController.view.frame
     
    if destination.origin.x > 0
      destination.origin.x = 0
      @visible = false
    else     
      destination.origin.x += 254.5
      @visible = true
    end
 
    UIView.animateWithDuration 0.25,
                               animations: -> { self.navigationController.view.frame = destination}
                                
    navigationController.visibleViewController.view.userInteractionEnabled = !(destination.origin.x > 0)
  end
   
  def self.menuButton(target, action)
    image_up = UIImage.imageNamed 'menu_up.png'
    image_down = UIImage.imageNamed 'menu_down.png'
    button = UIButton.buttonWithType(UIButtonTypeCustom)    
    button.addTarget(target, action: "#{action}", forControlEvents: UIControlEventTouchUpInside)
    button.setImage(image_up, forState:UIControlStateNormal)
    button.setImage(image_down, forState:UIControlStateHighlighted)
    button.frame = CGRectMake(0, 0, 35, 35)
    menuBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(button)
    
    return menuBarButtonItem
  end
   
end