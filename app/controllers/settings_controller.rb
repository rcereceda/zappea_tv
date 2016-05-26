class SettingsController < UIViewController

  include Helper

  attr_accessor :delegate
  
  def self.build
    @controller ||= alloc.initWithNibName(nil, bundle: nil)
  end
  
  def viewWillAppear(animated)
    super
    refresh
  end
  
  def viewDidLoad
    super
  
    self.title = 'Configuración'
    
    # back button
    image_up = UIImage.imageNamed 'menu_up.png'
    image_down = UIImage.imageNamed 'menu_down.png'
    setupLeftBarButton(image_up, image_down)
    
    self.navigationItem.hidesBackButton = true
    
    @table = UITableView.alloc.initWithFrame(self.view.bounds,
      style: UITableViewStyleGrouped)  
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table.backgroundColor = 0xCBD0D9.uicolor
    @table.backgroundView = nil
    self.view.addSubview(@table)

    @table.dataSource = self
    @table.delegate = self
    
    @switch = UISwitch.alloc.initWithFrame([[215, 9], [0, 0]])
    @switch.on = appDelegate.hd
    @switch.addTarget(self, action:'switchIsChanged', forControlEvents:UIControlEventValueChanged)
    
    @sections = ['HD', 'Cuenta', 'Acerca de']
    @rows = [1, 1, 1]
  end
  
  def handleLeftBarButton
    delegate.close
  end
  
  def refresh
    @table.reloadData
  end
  
  def remove
    getKeychain.remove
    refresh
  end
  
  def switchIsChanged
    if @switch.on?
      appDelegate.hd = true
    else
      appDelegate.hd = false
    end
    appDelegate.settings['hd'] = appDelegate.hd
    guideController = GuideController.build
    if guideController.category == 9
      guideController.category = 0
    end
    guideController.filter_programs
  end
  
  def rows_for_section(section_index)
    @data[self.sections[section_index]]
  end

  def row_for_index_path(index_path)
    rows_for_section(index_path.section)[index_path.row]
  end
  
  def sections
    @sections
  end
  
  def numberOfSectionsInTableView(tableView)
    self.sections.count
  end
  
  def tableView(tableView, numberOfRowsInSection: section)
    @rows[section]
  end
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleSubtitle,
        reuseIdentifier:@reuseIdentifier)
        
    cell.textLabel.font = :bold.uifont(16)
    cell.detailTextLabel.textColor = :darkgray.uicolor
    cell.detailTextLabel.font = :italic.uifont(14)
    
    if indexPath.section == 0
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell.textLabel.text = 'Canales HD'
      cell.contentView.addSubview(@switch)
    elsif indexPath.section == 1
      cell.imageView.image = UIImage.imageNamed('bird_big.png')
      if getKeychain.authorized?
        cell.textLabel.text = 'Salir de Twitter'
        cell.detailTextLabel.text = '@' + getKeychain.screen_name
      else
        cell.textLabel.text = 'Conectarse a Twitter'
        cell.detailTextLabel.text = 'Pincha aquí para conectarte'
      end
    elsif indexPath.section == 2
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.textLabel.text = 'Acerca de ...'
    end
    
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    cell = tableView.cellForRowAtIndexPath(indexPath)
    
    if indexPath.section == 1
      if getKeychain.authorized?
        cell.textLabel.text = 'Espere por favor...'
        self.performSelector('remove', withObject:nil, afterDelay:2.5)
      else
        presentOAuthView(self)
      end
    elsif indexPath.section == 2
      view_controller = InfoController.build

      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      self.parentViewController.pushViewController(view_controller, animated: true)
    end
  end
  
end