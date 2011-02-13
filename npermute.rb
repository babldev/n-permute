#!/usr/bin/ruby

# N-Permutation using only swaps.
# by Brady Law 2011

# Simple swapping of elements in an array given the indicies.
class Array
  def swap(x, y)
    temp = self[y]
    self[y] = self[x]
    self[x] = temp
  end
end


class NPermute
  attr_accessor :word, :size

  def initialize(size)
    @size = size
    @word = (1..@size).to_a

    @positions = (0...@size).to_a
    @directions = [-1] * @size
  end

  def iterate
    # First return the original word.
    yield @word.join, debug_str

    # Now,  the swap based off the book's algorithm.
    # Step 1: Find the optimal 'mobile' value. We are looking for the
    # maximum integer m such that @direction[m] is a valid movement
    # (in the range of 0..i).`
    done = false
    until done
      element = nil
      (0...@size).reverse_each do |i|
        if (0..i).include? ( @positions[i] + @directions[i] )
          element = i
          break
        end
      end

      break if element == nil  # If we can't move anything, we're done!

      offset = buffer(element)
      pos = @positions[element] + offset
      # Step 2: Make the swap, update the @positions data.
      word.swap(pos, pos + @directions[element])
      @positions[element] += @directions[element]

      # Step 3: Reverse the @directions for any integer p where p > move_pos.
      for i in (element + 1)...@size
        @directions[i] *= -1
      end

      yield @word.join,
        debug_str(:offset => offset,
        :element => element,
        :real_pos => pos + 1,
        :direction => @directions[element])
    end
  end

  def buffer(elem)
    buffer = 0
    for i in (elem+1)...@size
      buffer += 1 if @positions[i] == 0
    end
    buffer
  end

  # Generates a debug string including the movements of each integer.
  def debug_str(data=nil)
    output = ""
    (1...@size).reverse_each do |i|
      output += (i + 1).to_s + ": |" + ("." * @positions[i])
      output += @directions[i] == 1 ? ">" : "<"
      output += ("." * (i - @positions[i])) + "|   "
    end

    if data
      output += "\tShifted #{(data[:element] + 1).to_s} #{data[:direction] == 1 ? "right" : "left"}. "
      output += "\tSwapped (#{data[:real_pos]}, #{data[:real_pos] + data[:direction]})."
      output += "\tOffset: #{data[:offset]}"
    end

    output
  end
end



# Example code:
print "Enter word size (Max 9): "
count = gets.chomp.to_i
permuter = NPermute.new(count)

i = 0
permuter.iterate do |word, debug|
  i += 1
  puts "p#{i}" + (" " * (8 - i.to_s.length)) + word + "    " + debug
end
