class SearchController < UITableViewController

  attr_accessor :delegate
  
  def self.build
    @controller ||= alloc.initWithNibName(nil, bundle: nil)
  end

  def viewDidLoad
    super
    
    @search_bar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    @search_bar.placeholder = 'Canal o Programa'
    @search_bar.setShowsCancelButton(true, animated:true)
    #@search_bar.keyboardType = UIKeyboardTypeDefault
    @search_bar.barStyle = UIBarStyleBlackOpaque
    @search_bar.resignFirstResponder
    @search_bar.delegate = self
    
    view.addSubview(@search_bar)
    view.tableHeaderView = @search_bar
    
    @programs = []
    @channel_results = []
    @program_results = []
    
    @sections = ['Canales', 'Programas']
  end
  
  def close
    delegate.close
  end
  
  def viewDidAppear(animated)
    @search_bar.becomeFirstResponder
  end
  
  def viewWillAppear(animated)
    # hidde bar
    self.navigationController.navigationBarHidden = true
    
    read_programs
  end

  def read_programs
    guideController = GuideController.build
    @programs = guideController.programs
  end
  
  def searchBarTextDidBeginEditing(search_bar)
    search_bar.showsCancelButton = true
    for subView in search_bar.subviews do
      if subView.isKindOfClass(NSClassFromString('UINavigationButton'))
        cancelButton = subView
        cancelButton.setTitle('Cancelar', forState:UIControlStateNormal)
      end
    end
    search_bar.autocorrectionType = UITextAutocorrectionTypeNo
  end
  
  def searchBarCancelButtonClicked(search_bar)
    close
  end
  
  def searchBarSearchButtonClicked(search_bar)
    search_bar.resignFirstResponder
    search_for(search_bar.text)
    search_bar.text = ''
  end
  
  def search_for(text)
    @channel_results = @programs.select { |program| program.name.downcase.include? text.downcase}
    #@channel_results = @channel_results.select { |program| program.number.nil? == false }
    @program_results = @programs.select { |program| program.title.downcase.include? text.downcase}
    view.reloadData
  end
  
  ## Table view data source
  
  def sections
    @sections
  end
  
  def numberOfSectionsInTableView(tableView)
    if @channel_results.to_a.length > 0 && @program_results.to_a.length > 0
      2
    else
      1
    end
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
    if @channel_results.to_a.length > 0
      sections[section]
    elsif @program_results.to_a.length > 0
      sections[section + 1]
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if @channel_results.to_a.length > 0 && @program_results.to_a.length > 0
      if section == 0
        @channel_results.to_a.length
      else
        @program_results.to_a.length
      end
    elsif @channel_results.to_a.length > 0
      @channel_results.to_a.length
    else
      @program_results.to_a.length
    end
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cellIdentifier = self.class.name
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) || 
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:cellIdentifier)

    channel = @channel_results[indexPath.row]
    program = @program_results[indexPath.row]
    
    if @channel_results.to_a.length > 0 && @program_results.to_a.length > 0
      if indexPath.section == 0
        cell.textLabel.text = channel.name
      else
        cell.textLabel.text = program.title
      end
    elsif @channel_results.to_a.length > 0
      cell.textLabel.text = channel.name
    else
      cell.textLabel.text = program.title
    end
    
    cell.textLabel.font = :bold.uifont(12)
    cell.textLabel.textColor = :darkgray.uicolor
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    if @channel_results.to_a.length > 0 && @program_results.to_a.length > 0
      if indexPath.section == 0
        row = @channel_results[indexPath.row]
      else
        row = @program_results[indexPath.row]
      end
    elsif @channel_results.to_a.length > 0
      row = @channel_results[indexPath.row]
    else
      row = @program_results[indexPath.row]
    end
    
    view_controller = ProgramController.alloc.initWithProgram(row)
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.parentViewController.pushViewController(view_controller, animated: true)
    
    # show bar
    self.navigationController.navigationBarHidden = false
  end
  
end