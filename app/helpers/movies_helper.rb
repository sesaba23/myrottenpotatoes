module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  # Highlight background if necesary returning 'hilite' class name according with default.css style
  def yellow_background(column)
  	@ordered_by == column ? 'hilite' : ''
  end

  # helper method in order to return a hash with pair-value 'order_by: column'
  # 'order' pretend tu switch between ascending / descending order but it is pending
  def create_order_params(column, order=true)
	{:order_by=> column, :asc=>true}
  end

end
