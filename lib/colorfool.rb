module ColorFool
  COLORS = %i(green red)
  
  CODES = {
    black:   30,
    red:     31,
    green:   32,
    yellow:  33,
    blue:    34,
    magenta: 35,
    cyan:    36,
    white:   37
  }
  
  def code(color)
    CODES[color]
  end
  
  def colorize(color, &block)
    code    = code(color)
    content = block.call.to_s
    
    "\e[#{code}m#{content}\e[0m"
  end
end
