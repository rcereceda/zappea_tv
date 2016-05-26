class WriteViewController < UIViewController

  include Constant
  include Helper
  
  def initWithHashtag(program)
    @program = program
    init
  end

  def viewDidLoad
    super
    if Device.screen.height == 480
      height = 140
    else
      height =  228
    end
    
    # custom navigation background image
    image = UIImage.imageNamed('bar.png') 
    self.navigationController.navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetricsDefault)
    
    # navbar: title view
    @title_view = UIView.alloc.initWithFrame([[0, 0], [220, 44]])
    @title_view.backgroundColor = :clear.uicolor
    
    # navbar: label title
    @text = UILabel.alloc.initWithFrame([[0, 5], [220, 22]])
    @text.text = 'Nuevo Tuiteo'
    @text.textAlignment = UITextAlignmentCenter
    @text.font = :bold.uifont(14)
    @text.textColor =  :white.uicolor
    @text.backgroundColor = :clear.uicolor
    # navbar: label time
    @title = UILabel.alloc.initWithFrame([[0, 20], [220, 22]])
    @title.text = @program.title
    @title.textAlignment = UITextAlignmentCenter
    @title.font = :bold.uifont(12)
    @title.textColor =  :white.uicolor
    @title.backgroundColor = :clear.uicolor
    
    # navbar: assign labels to title view
    @title_view.addSubview(@text)
    @title_view.addSubview(@title)
    self.navigationItem.titleView = @title_view
    
    # navbar: buttons
    image_up = UIImage.imageNamed 'ok_up.png'
    image_down = UIImage.imageNamed 'ok_down.png'
    setupRightBarButton(image_up, image_down)
    image_up = UIImage.imageNamed 'close_up.png'
    image_down = UIImage.imageNamed 'close_down.png'
    setupLeftBarButton(image_up, image_down)

    self.view.backgroundColor = :white.uicolor
    
    # comment
    if @program.comment
      comment = @program.comment
    else
      comment = ' ' + @program.hashtag
    end

    @textView = UITextView.alloc.initWithFrame([[5, 5], [self.view.frame.size.width - 10, height]])
    @textView.text = comment
    @textView.font = :system.uifont(14)
    @textView.selectedRange = NSMakeRange(0, 0);
    @textView.editable = true
    @textView.backgroundColor = :clear.uicolor
    @textView.becomeFirstResponder
    @textView.delegate = self
    self.view.addSubview @textView
    
    @label_lenght = UILabel.alloc.initWithFrame([[280, @textView.position.y + @textView.frame.size.height/2 + 24], [30, 20]])
    @label_lenght.text = (140 - @program.hashtag.length).to_s
    @label_lenght.font = :italic.uifont(16)
    @label_lenght.textColor =  :darkgray.uicolor
    @label_lenght.backgroundColor = :clear.uicolor
    @label_lenght.textAlignment = UITextAlignmentRight
    self.view.addSubview @label_lenght
  end
  
  def textView(textView, shouldChangeTextInRange:range, replacementText:text)
    newLength = @textView.text.length + text.length - range.length
    return (newLength > 140) ? false : true && @label_lenght.text = (140 - newLength).to_s
  end

  def handleRightBarButton
    keychain = getKeychain.fetch
    @request = OAuth::Request.new(
      consumer_key: CONSUMER_KEY,
      consumer_secret: CONSUMER_SECRET,
      access_token: keychain['oauth_token'], 
      access_token_secret: keychain['oauth_token_secret'],
    )
    
    tweet = @textView.text
            .gsub('á','a')
            .gsub('é','e')
            .gsub('í','i')
            .gsub('ó','o')
            .gsub('ú','u')
            .gsub('ü','u')
            .gsub('ñ','n')
            
    params = {
      status: tweet,
    }
    
    @request.post('https://api.twitter.com/1.1/statuses/update.json',
                  params) do |res|
      unless res.ok?
      end
    end
    
    self.dismissViewControllerAnimated(true, completion:nil)
  end

  def handleLeftBarButton
    self.dismissViewControllerAnimated(true, completion:nil)
  end

end
