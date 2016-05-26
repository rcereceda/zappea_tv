class OAuthTableViewController < UITableViewController

  include Helper
  include Twitter
  
  attr_accessor :delegate
  
  StatusCellIdentifier = 'StatusCell'

  def initWithProgram(program)
    @program = program
    init
  end
  
  def init
    if super
      @items ||= [] 
    end
    self
  end

  def viewWillAppear(animated)
    super
    @indicator.startAnimating
    getTweets
  end

  def viewDidLoad
    super
    if Device.screen.height == 480
      height = 372
    else
      height =  460
    end
    
    self.view.frame = [[0, 0], [320, height]]
    buildIndicator
    @indicator.hidesWhenStopped = true
  end

  def viewDidAppear(animated)
    # viewWillAppear
    @refreshHeaderView ||= begin
      rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
      rhv.delegate = self
      self.tableView.addSubview(rhv)
      rhv
    end
  end

  def numberOfSectionsInTableView(tableView)
    1  
  end
  
  def tableView(tableView, numberOfRowsInSection:section) 
    @items.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(StatusCellIdentifier) ||
      TweetCell.alloc.initWithReuseIdentifier(StatusCellIdentifier)
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.tweet = @items[indexPath.row]
    cell
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    TweetCell.heightForCellWithTweet(@items[indexPath.row])
  end
  
  def getTweets
    if getKeychain.authorized?
      @reloading = true#
      fetchTweet @program.hashtag do |res|
        if res.ok?
          self.tableView.reloadData
          @reloading = false#
          @indicator.stopAnimating
        end
      end
    else
      @reloading = false#
      @indicator.stopAnimating
      self.delegate.presentAuthorize
    end
  end
  
  def buildIndicator
    @indicator = UIActivityIndicatorView.gray
    @indicator.frame = [[150, 196], [20, 20]]
    self.view.addSubview(@indicator)
  end
  
  # Table Scroll Refresh
  
  def reloadTableViewDataSource
    @reloading = true
  end
  
  def doneReloadingTableViewData
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
  end
  
  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end
  
  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end
    
  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end

end
