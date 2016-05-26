class OAuthViewController < UIViewController

  include Helper
  include Constant
  
  attr_accessor :delegate

  def viewDidLoad
    super
    
    # custom navigation background image
    image = UIImage.imageNamed('bar.png') 
    self.navigationController.navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetricsDefault)

    image_up = UIImage.imageNamed 'close_up.png'
    image_down = UIImage.imageNamed 'close_down.png'
    setupLeftBarButton(image_up, image_down)
    
    self.title = 'Cargando...'
    
    self.view.backgroundColor = :white.uicolor

    @first = true
    @link = false

    @consumer = OAuth::Consumer.new(
      consumer_key: CONSUMER_KEY,
      consumer_secret: CONSUMER_SECRET,
      request_token_url: REQUEST_TOKEN_URL,
      authorize_url: AUTHORIZE_URL,
      access_token_url: ACCESS_TOKEN_URL,
    )

    @consumer.get_request_token do |res|
      if res.ok?
        webView = UIWebView.alloc.initWithFrame(self.view.bounds)
        webView.delegate = self
        self.view.addSubview(webView)
        request = NSURLRequest.requestWithURL(NSURL.URLWithString(res.authorize_url))
        if webView.loadRequest(request)
          self.title = 'Loguéate y Comparte'
        end
      end
    end
  end

  def webViewDidFinishLoad(webView)
    
    if @first || @link
      @first = false
      return
    end

    verifier = @consumer.get_verifier(webView)
    if verifier == nil
      @link = true
      handleLeftBarButton
      return
    end
    
    @consumer.get_access_token(verifier) do |res|
      getKeychain.store(res)
      self.delegate.refresh if self.delegate.respond_to?"refresh" # SettingsController
      self.dismissViewControllerAnimated(true, completion:nil)
    end
  end

  def handleLeftBarButton
    self.delegate.change if self.delegate.respond_to?"change" # ProgramController
    self.dismissViewControllerAnimated(true, completion:nil)
  end
end

