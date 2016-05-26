class FilterProgramsController < UIViewController

  include Helper
  
  attr_accessor :delegate
  
  def viewDidLoad
    super
  
    self.title = 'Ordenar & Filtrar'
    
    # custom navigation background image
    image = UIImage.imageNamed('bar.png') 
    self.navigationController.navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetricsDefault)
    
    # ok button
    image_up = UIImage.imageNamed 'ok_up.png'
    image_down = UIImage.imageNamed 'ok_down.png'
    setupRightBarButton(image_up, image_down)
    
    @table = UITableView.alloc.initWithFrame(self.view.bounds,
      style: UITableViewStyleGrouped)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table.backgroundColor = 0xCBD0D9.uicolor
    @table.backgroundView = nil
    self.view.addSubview(@table)

    @table.dataSource = self
    @table.delegate = self

    @filter = []
    @filter = ['Todo', 'Nacionales', 'Películas', 'Deportes', 'Infantil', 'Tendencias', 'Noticias', 'Música', 'Series & Más']
    
    if appDelegate.hd
      @filter << 'HD'
    else
      @filter.delete('HD')
    end
    
    @sort = []
    @sort = ['Tuiteos', 'Horario']
    
    @sections = ['Ordenar por', 'Categoría']
  end
  
  def handleRightBarButton
    delegate.filter_programs
    delegate.close_filter
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
  
  def tableView(tableView, titleForHeaderInSection:section)
    sections[section]
  end
  
  def tableView(tableView, numberOfRowsInSection: section)
    if section == 0
      @sort.count
    else
      @filter.count
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"
    
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell = UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:@reuseIdentifier)
    
    if indexPath.section == 0
      cell.textLabel.text = @sort[indexPath.row]
    else
      cell.textLabel.text = @filter[indexPath.row]
    end
    
    if indexPath.row == delegate.sort && indexPath.section == 0
      cell.accessoryType = UITableViewCellAccessoryCheckmark
    end
    if indexPath.row == delegate.category && indexPath.section == 1
      cell.accessoryType = UITableViewCellAccessoryCheckmark
    end
    
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if indexPath.section == 0
      delegate.sort = indexPath.row
    else
      delegate.category = indexPath.row
    end
    
    @table.reloadData
  end
  
end