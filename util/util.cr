module Util
  extend self

  def print_point_map(hashmap, rcol = false, rrow = false)
    rows = hashmap.map { |k, _| k.x }
    rmin, rmax = rows.min, rows.max
    cols = hashmap.map { |k, _| k.y }
    cmin, cmax = cols.min, cols.max
    col_range = (cmin..cmax).to_a
    col_range = col_range.reverse if rcol
    row_range = (rmin..rmax).to_a
    row_range = row_range.reverse if rrow
    col_range.each { |c|
      row_range.each { |r|
        print yield r, c, hashmap[Point.new r, c]?
      }
      print "\n"
    }
  end
end
