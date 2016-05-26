Teacup::Stylesheet.new :cell_sheet do

# TableView
  style :box,
    frame: [[0, 0], [50, 70]],
    gradient: { 
      colors: [
        :lightgray.uicolor, 
        :gray.uicolor
      ] 
    }
    
  style :channel,
    frame: [[0, '35%'], [50, 36]]
  
  style :hd,
      frame: [[32.5, 52.5], [15, 15]],
      font: :bold.uifont(10),
      backgroundColor: :clear.uicolor,
      textColor: :white.uicolor,
      textAlignment: UITextAlignmentCenter,
      shadowColor: :darkgray.uicolor
  
  style :number,
      frame: [[22.5, 1], [25, 15]],
      font: :bold.uifont(10),
      backgroundColor: :clear.uicolor,
      textColor: :white.uicolor,
      textAlignment: UITextAlignmentRight,
      shadowColor: :darkgray.uicolor
      
  style :bar,
    frame: [[55, '140%'], [100, 5]],
    backgroundColor: 0xCBD0D9.uicolor
    
  style :progress_limit,
    frame: [[55, '140%'], [1, 5]],
    image: UIImage.imageNamed('progress_limit')
  
  style :progress,
    frame: [[55, '140%'], [0, 5]],
    backgroundColor: UIColor.colorWithPatternImage(UIImage.imageNamed('progress'))
  
  style :program,
    frame: [[55, '12.5%'], [100, 56]]

  style :title,
    font: :system.uifont(14),
    frame: [[165, '12.5%'], [120, 25]],
    lineBreakMode: UILineBreakModeTailTruncation,
    numberOfLines: 2

  style :time,
    frame: [[165, '100%'], [120, 20]],
    font: :system.uifont(12),
    textColor: :gray.uicolor

  style :audience,
    frame: [[290, '12.5%'], [27, 25]],
    font: :bold.uifont(14),
    textColor: 0x00ADE8.uicolor,
    textAlignment: UITextAlignmentCenter

  style :logo,
    frame: [[295, '100%'], [14, 11]]
    
  style :separator,
    frame: [[0, 0],['100%', 10]],
    backgroundColor: :gray.uicolor

end