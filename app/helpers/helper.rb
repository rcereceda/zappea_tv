module Helper
  def appDelegate
    UIApplication.sharedApplication.delegate
  end
  
  def getKeychain
    appDelegate.keychain
  end
  
  def setupButton(image_up, image_down, action)
    button = UIButton.buttonWithType(UIButtonTypeCustom)    
    button.addTarget(self, action: action, forControlEvents: UIControlEventTouchUpInside)
    button.setImage(image_up, forState:UIControlStateNormal)
    button.setImage(image_down, forState:UIControlStateHighlighted)
    button.frame = CGRectMake(0, 0, 35, 35)
    buttonItem = UIBarButtonItem.alloc.initWithCustomView(button)
  end
  
  def setupRightBarButton(image_up, image_down)
    self.navigationItem.rightBarButtonItem = setupButton(image_up, image_down, "handleRightBarButton")
  end
  
  def setupLeftBarButton(image_up, image_down)
    self.navigationItem.leftBarButtonItem = setupButton(image_up, image_down, "handleLeftBarButton")
  end

  def presentOAuthView(controller)
    @oauthViewController = OAuthViewController.alloc.init
    @oauthViewController.delegate = controller
    @oauthNaviController = UINavigationController.alloc.initWithRootViewController(@oauthViewController)
    self.presentViewController(@oauthNaviController, animated: true, completion: nil)
  end

  def presentWriteView(program)
    @writeViewController = WriteViewController.alloc.initWithHashtag(program)
    @writeNaviController = UINavigationController.alloc.initWithRootViewController(@writeViewController)
    self.presentViewController(@writeNaviController, animated: true, completion: nil)
  end
end
