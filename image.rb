class Image
  attr_accessor :pixels

  def initialize(pixels)
    self.pixels = pixels
  end
  def blur(n)
    oldArr = Array.new(self.pixels)
    newArr = Array.new(self.pixels)
    rows = Array.new
    columns = Array.new
    oldArr.each_index { |i|  # Going through each row
      if oldArr[i].index(1) != nil  # If 1 is in the row somewhere 
        oldArr[i].each_index { |j|        # go through each element in the row
          if oldArr[i][j] == 1        #if element is 1, replace adjacent elements with a 1
            rows.push(i)
            columns.push(j)
          end
        }
      end
    }
    rows.each_index { |r|
      count = 0
      row_orig = rows[r]
      col_orig = columns[r]

      while count < n    # where n is the distance
        pix_count = 0
        row_col_arr = []
        col = col_orig - count
        last_col = col_orig + count
        if last_col >= newArr[0].length
          last_col = newArr[0].length - 1
        end                                 #Making sure we don't exceed array dimensions
        if col < 0
          col = 0
        end
        while col <= last_col
          if col < col_orig
            row = (col - (col_orig-count)) + row_orig
            if row >= 0 && row < newArr.length
              row_col_arr.push([row, col])
            end
            if col > col_orig - count
              row = -(col - (col_orig-count)) + row_orig
              if row >= 0 && row < newArr.length
                row_col_arr.push([row, col])
              end
            end
          else
            row = (col - (col_orig+count)) + row_orig
            if row >= 0 && row < newArr.length
              row_col_arr.push([row, col])
            end
            if col < col_orig + count
              row = -(col - (col_orig+count)) + row_orig
              if row >= 0 && row < newArr.length
                row_col_arr.push([row, col])
              end
            end
          end
          col = col + 1
        end
        while pix_count < row_col_arr.length   # number of pixels to be blurred at this step

          blur_pixel(row_col_arr[pix_count][0], row_col_arr[pix_count][1], newArr)
          pix_count = pix_count + 1
        end
        count = count + 1
        
      end
    }
    self.pixels.replace(newArr)
    # puts "#{newArr.object_id};; #{oldArr.object_id}"
  end
  def output_image
    self.pixels.each { |a| a.each { |x| print x }; print "\n"}
  end

  def blur_pixel(row, col, newArr)    # blurs a single pixel
    if row+1 < self.pixels.length
      newArr[row+1][col] = 1
    end
    if row-1 >= 0
      newArr[row-1][col] = 1
    end
    if col+1 < self.pixels.length
      newArr[row][col+1] = 1
    end
    if col-1 >= 0
      newArr[row][col-1] = 1
    end
  end
end

image = Image.new([
  [1, 0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 1],
  [0, 0, 0, 0]

])
array = Array.new(50) { Array.new(50, 0) }
array[4][7] = 1
array[13][11] = 1
array[29][37] = 1
array[42][6] = 1
image2 = Image.new(array)
image2.output_image
puts "-----------------------------------------"
image2.blur(15)
image2.output_image