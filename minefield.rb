class Minefield
  attr_reader :row_count, :column_count, :mine_field

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @mine_field = {:cover => [] , :bombs => []}
    for i in (0..@column_count-1)
      @mine_field[:cover] << []
      @mine_field[:bombs] << []
      for r in (0..@row_count-1)
        @mine_field[:cover][i] << false
        @mine_field[:bombs][i] << false
      end
    end
    @mine_count.times do |a|
      column = rand(0..@column_count-1)
      row = rand(0..@row_count-1)
        if @mine_field[:bombs][column][row] != true
          @mine_field[:bombs][column][row] = true
        else
          while @mine_field[:bombs][column][row] == true
            column = rand(0..@column_count-1)
            row = rand(0..@row_count-1)
            if @mine_field[:bombs][column][row] != true
              @mine_field[:bombs][column][row] = true
              break
            end
          end
        end
    end
  end





  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    if @mine_field[:cover][col][row] == true
      return true
    else
      return false
    end
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
      squares = adjacent_clear(row,col)
      squares.each { |position| uncover(position[0],position[1]) }
  end

  #this method checks all the adjacent squares for adjacent mines, and returns an array with all the rows and columns nearby that do not have adjacent mines.

  def adjacent_clear(row,col)
    square = 1
    breaker = 0
    rowscols = []
    possibilities = [[row + square,col],[row,col + square],[row + square,col + square],[row - square,col],[row,col - square],[row - square,col - square],[row + square, col - square], [row - square, col + square]]
    if adjacent_mines(row,col) == 0 && row + square <= @row_count && row - square >= 0 && col + square <= @column_count && col - square >= 0
      possibilities.each do |position|
        rowscols << position
      end
      while row + square <= @row_count && row - square >= 0 && col + square <= @column_count && col - square >= 0
        square += 1
        possibilities.each do |check|
          breaker += adjacent_mines(check[0],check[1])
        end
        if breaker == 0
          possibilities.each do |check|
            rowscols << check
          end
        else
          break
        end
        possibilities = [[row + square,col],[row,col + square],[row + square,col + square],[row - square,col],[row,col - square],[row - square,col - square],[row + square, col - square], [row - square, col + square]]
      end
    end
      rowscols << [row,col]
      rowscols
  end

  #this method uncovers a square.

  def uncover(row,col)
    @mine_field[:cover][col][row] = true
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    for i in (0..@mine_field[:cover].size-1)
      for r in (0..@mine_field[:cover][0].size-1)
        if @mine_field[:cover][i][r] == true && @mine_field[:bombs][i][r] == true
          return true
        end
      end
    end
    return false
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    for i in (0..@mine_field[:bombs].size-1)
      for r in (0..@mine_field[:bombs][0].size-1)
        if @mine_field[:bombs][i][r] == @mine_field[:cover][i][r]
          return false
        else
          return true
        end
      end
    end
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    @total = 0
  if @mine_field[:bombs][col-1][row] == true
      @total+=1
  end
  if @mine_field[:bombs][col-1][row-1] == true
      @total+=1
  end
  if @mine_field[:bombs][col-1][row+1] == true
      @total+=1
  end
  if @mine_field[:bombs][col+1][row] == true
      @total+=1
  end
  if @mine_field[:bombs][col+1][row-1] == true
      @total+=1
  end
  if @mine_field[:bombs][col+1][row+1] == true
      @total+=1
  end
  if @mine_field[:bombs][col][row-1] == true
      @total+=1
  end
  if @mine_field[:bombs][col][row+1] == true
      @total+=1
  end
    @total
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    if @mine_field[:bombs][col][row] == true && @mine_field[:cover][col][row] == true
      return true
    else
      return false
    end
  end
end
