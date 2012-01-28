# malloc - Raw memory allocation for Ruby
# Copyright (C) 2010 Jan Wedekind
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# String#bytesize is defined if it does not exist already
class String

  unless method_defined? :bytesize

    # String#bytesize is defined if it does not exist already
    #
    # Provided for compatibility with Ruby 1.8.6. Same as #size.
    #
    # @private
    def bytesize
      size
    end

  end

end

# Namespace of the Hornetseye project.
module Hornetseye

  # Class for allocating raw memory and for doing pointer operations
  class Malloc

    class << self

      # Create new Malloc object
      #
      # Allocate the specified number of bytes of raw memory.
      #
      # @example Allocate raw memory
      #   m = Malloc.new 32
      #   # Malloc(32)
      #
      # @param [Integer] size Number of bytes to allocate.
      # @return [Malloc] A new Malloc object.
      #
      # @see Malloc
      def new( size )
        retval = orig_new size
        retval.instance_eval { @size = size }
        retval
      end

      private :orig_new

    end

    # Number of bytes allocated
    #
    # @example Querying size of allocated memory
    #   m = Malloc.new 32
    #   m.size
    #   # 32
    #   ( m + 8 ).size
    #   # 24
    #
    # @return [Integer] Size of allocated memory.
    attr_reader :size

    # Display information about this object
    #
    # @example Displaying information about a Malloc object
    #   Malloc.new( 8 ).inspect
    #   "Malloc(8)"
    #
    # @return [String] A string with information about this object.
    def inspect
      "Malloc(#{@size})"
    end

    # Duplicate object
    #
    # @example Duplicating a Malloc object
    #   m = Malloc.new 3
    #   m.write 'aaa'
    #   n = m.dup
    #   n.write 'bbb'
    #   m.read 3
    #   "aaa"
    #
    # @return [Malloc] A new malloc object with a copy of the data.
    def dup
      retval = Malloc.new @size
      retval.write self
      retval
    end

    # Display information about this object
    #
    # @example Displaying information about a Malloc object
    #   Malloc.new( 8 ).to_s
    #   "Malloc(8)"
    #
    # @return [String] A string with information about this object.
    def to_s
      inspect
    end

    # Read complete data
    #
    # @example Export to string
    #   m = Malloc.new 3
    #   m.write 'abc'
    #   m.export
    #   "abc"
    def export
      read @size
    end

    # Operator for doing pointer arithmetic
    #
    # @example Pointer arithmetic
    #   m = Malloc.new 4
    #   # Malloc(4)
    #   m.write 'abcd'
    #   n = m + 2
    #   # Malloc(2)
    #   n.read 2
    #   # "cd"
    #
    # @param [Integer] offset Non-negative offset for pointer.
    # @return [Malloc] A new Malloc object.
    def +( offset )
      if offset > @size
        raise "Offset must not be more than #{@size} (but was #{offset})"
      end
      mark, size = self, @size - offset
      retval = orig_plus offset
      retval.instance_eval { @mark, @size = mark, size }
      retval
    end

    private :orig_plus

    # Read data from memory
    #
    # @example Reading and writing data
    #   m = Malloc.new 4
    #   # Malloc(4)
    #   m.write 'abcd'
    #   m.read 2
    #   # "ab"
    #
    # @param [Integer] length Number of bytes to read.
    # @return [String] A string containing the data.
    #
    # @see #write
    # @see #to_s
    def read( length )
      raise "Only #{@size} bytes of memory left to read " +
        "(illegal attempt to read #{length} bytes)" if length > @size
      orig_read length
    end

    private :orig_read

    # Write data to memory
    #
    # @example Reading and writing data
    #   m = Malloc.new 4
    #   # Malloc(4)
    #   m.write 'abcd'
    #   m.read 2
    #   # "ab"
    #
    # @param [String,Malloc] data A string or malloc object with the data.
    # @return [String] Returns the parameter +string+.
    #
    # @see #read
    def write( data )
      if data.is_a? Malloc
        if data.size > @size
          raise "Must not write more than #{@size} bytes of memory " +
            "(illegal attempt to write #{data.size} bytes)"
        end
        orig_write data, data.size
      else
        if data.bytesize > @size
          raise "Must not write more than #{@size} bytes of memory " +
            "(illegal attempt to write #{data.bytesize} bytes)"
        end
        orig_write data
      end
    end

    private :orig_write

  end

  # Shortcut for instantiating Malloc object
  #
  # @example Create malloc object
  #   m = Malloc 4
  #   # Malloc(4)
  #
  # @param [Integer] size Number of bytes to allocate.
  # @return [Malloc] A new Malloc object.
  #
  # @see Malloc.new
  def Malloc( size )
    Malloc.new size
  end

  module_function :Malloc

end
