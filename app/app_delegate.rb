VERSION = '1.2.0'

class AppDelegate
  
  include Constant
  
  attr_accessor :data, :settings, :provider, :hd, :begin, :keychain
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    
    # twitter keychain
    @keychain = OAuth::Keychain.new(CONSUMER_KEY)
    
    # appearance
    Teacup::Appearance.apply
    
    # program images cache
    self.data = {}
    # settings
    self.settings = NSUserDefaults.standardUserDefaults
    
    # reviewed & counter
    unless self.settings['reviewed']
      self.settings['counter'] = 7
    end
    
    # hd channels
    unless self.settings['hd'].nil?
      self.hd = self.settings['hd']
    else
      self.hd = true
    end
    
    # vtr=0, claro=1, movistar=2, directv=3
    if self.settings['provider']
      self.provider = self.settings['provider']
    else
      self.provider = 0
    end
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # left side menu view
    menuManager = MenuManager.instance
    @window.rootViewController = menuManager.navigationController
    @window.makeKeyAndVisible
    
    #Need to call this here for now till we start passing through the @window to MenuManager
    menuManager.setupMenuView
    
    config
    
    true
  end
  
  def applicationDidEnterBackground(application)
    self.data = {}
  end
  
  def applicationWillEnterForeground(application)
    guideController = GuideController.build
    guideController.refresh
    
    config
  end
  
  def config
    check_version
  end
  
  def check_version
    # api config                                           
    @config ||= []
    ApiClient.load_config do |success, config|
      if success
        @config = config
        # last version?
        current_itunes = @config[0].version.split('.')
        current_local = VERSION.split('.')
        if (current_itunes[0].to_i > current_local[0].to_i) || 
          (current_itunes[0].to_i == current_local[0].to_i && current_itunes[1].to_i > current_local[1].to_i) ||
          (current_itunes[0].to_i == current_local[0].to_i && current_itunes[1].to_i == current_local[1].to_i && current_itunes[2].to_i > current_local[2].to_i)
          @alert_url = @config[0].url
          @alert_title = UPDATE_TITLE
          @alert_text = @config[0].message
          @alert_no = UPDATE_NO
          @alert_ok = UPDATE_OK
          show_alert
        else
          unless self.settings['reviewed']
            check_review
          end
        end
      end
    end
  end
  
  def check_review
    self.settings['counter'] -= 1
    if self.settings['counter'] == 0
      @alert_url = UIDevice.currentDevice.systemVersion.floatValue >= 7.0? IOS7_APPSTORE_URL : IOS_APPSTORE_URL
      @alert_title = REVIEW_TITLE
      @alert_text = REVIEW_TEXT
      @alert_no = REVIEW_NO
      @alert_ok = REVIEW_OK
      show_alert
    end
  end

  def show_alert
    alert = UIAlertView.alloc
    alert.send(:"initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:",
                @alert_title, @alert_text, self, @alert_no, @alert_ok, nil)
    alert.show
  end

  def alertView(alert_view, clickedButtonAtIndex:button_index)
    if button_index == 1
      if @alert_title == REVIEW_TITLE
        self.settings['reviewed'] = true
      end
      url = @alert_url
      url.nsurl.open
    else
      if @alert_title == REVIEW_TITLE
        self.settings['reviewed'] = true
      end
    end
  end
  
end