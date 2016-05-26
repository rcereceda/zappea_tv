class SideMenuController < UITableViewController
   
  def self.build
    @controller ||= alloc.initWithNibName(nil, bundle: nil)
  end
 
  def viewDidLoad
    super
     
    @controllers = [GuideController.build, 
                    SearchController.build,
                    SettingsController.build]
    
    @controllers.each do |c|
       c.delegate = self
    end
 
    @labels = ['Inicio', 'Buscar', 'Configuración']
    @icons = ['home', 'search', 'settings'] 
     
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.backgroundColor = 0x303030.uicolor
    
  end
  
  def close
    MenuManager.instance.toggleMenuState
  end
 
  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    if (indexPath.row == 0)
      height = 50
    else
      height = 50
    end
     
    return height
  end
 
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "MenuCell"
     
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)
       
    up = UIImageView.alloc.initWithFrame([[0, 0], [254.5, 50]])
    up.backgroundColor = :clear.uicolor
    up.opaque = false
    up.image = UIImage.imageNamed('menu_bar_up.png')
    cell.backgroundView = up
    
    down = UIImageView.alloc.initWithFrame([[0, 0], [254.5, 50]])
    down.backgroundColor = :clear.uicolor
    down.opaque = false
    down.image = UIImage.imageNamed('menu_bar_down.png')
    cell.selectedBackgroundView = down
         
    label = UILabel.alloc.initWithFrame([[55, 10], [150, 30]])
    label.text = @labels[indexPath.row]
    label.font = :system.uifont(14)
    label.textColor = :lightgray.uicolor
    label.highlightedTextColor = :white.uicolor
    label.shadowColor = :black.uicolor
    label.backgroundColor = :clear.uicolor
    label.textAlignment = UITextAlignmentLeft
    
    icon = UIImageView.alloc.initWithFrame([[15, 10], [30, 30]])
    icon.image = UIImage.imageNamed(@icons[indexPath.row] + '_up.png')
    icon.highlightedImage = UIImage.imageNamed(@icons[indexPath.row] + '_down.png')
     
    cell.contentView.addSubview label
    cell.contentView.addSubview icon
 
    return cell
  end
   
  def tableView(tableView, numberOfSectionsInTableView: sections)
    return 1
  end
 
  def tableView(tableView, numberOfRowsInSection: section)
    return @controllers.length
  end
   
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    menuManager = MenuManager.instance
    
    if indexPath.row == 1
      menuManager.navigationController.navigationBarHidden = true
    else
      menuManager.navigationController.navigationBarHidden = false
    end
 
    #Return only the controller we want to display but needs to be in array
    menuManager.navigationController.viewControllers = [@controllers[indexPath.row]]    
    menuManager.toggleMenuState
  end
   
end