class InfoController < UIViewController

  include Helper
  
  def self.build
    @controller ||= alloc.initWithNibName(nil, bundle: nil)
  end
  
  def loadView
    self.view = UIWebView.alloc.init
  end

  def viewDidLoad
    super
    
    self.title = 'Cargando...'
    
    # back button
    image_up = UIImage.imageNamed 'back_up.png'
    image_down = UIImage.imageNamed 'back_down.png'
    setupLeftBarButton(image_up, image_down)
    
    self.navigationItem.hidesBackButton = true
    
    # web view
    BW::HTTP.get("http://app.zappea.tv/about.htm") do |response|
      if response.ok?
        self.view.loadHTMLString(response.body.to_s, baseURL:nil)
        self.title = 'Acerca de'
      end
    end
        
  end
  
  def handleLeftBarButton
    self.navigationController.popViewControllerAnimated(true)
  end

end