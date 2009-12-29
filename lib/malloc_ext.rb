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
      # require 'malloc'
      # include Hornetseye
      # m = Malloc.new 32
      # # Malloc(32)
      #
      # @param [size] Number of bytes to allocate.
      # @return [Malloc] A new Malloc object.
      def new( size )
        retval = orig_new size
        retval.instance_eval { @size = size }
        retval
      end

      private :orig_new

    end

    # Number of bytes allocated
    #
    # @return [Integer] Size of allocated memory.
    attr_reader :size

    # Display information about this object
    #
    # @return [String] A string with information about this object.
    def inspect
      "Malloc(#{@size})"
    end

    # Read data from memory
    #
    # @return [String] A string containing the data.
    #
    # @see #read
    def to_s
      read @size
    end

    # Operator for doing pointer arithmetic
    #
    # @example Pointer arithmetic
    # require 'malloc'
    # include Hornetseye
    # m = Malloc.new 4
    # # Malloc(4)
    # m.write 'abcd'
    # n = m + 2
    # # Malloc(2)
    # n.read 2
    # # "cd"
    #
    # @param [offset] Non-negative offset for pointer.
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
    # require 'malloc'
    # include Hornetseye
    # m = Malloc.new 4
    # # Malloc(4)
    # m.write 'abcd'
    # m.read 2
    # # "ab"
    #
    # @param [length] Number of bytes to read.
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
    # require 'malloc'
    # include Hornetseye
    # m = Malloc.new 4
    # # Malloc(4)
    # m.write 'abcd'
    # m.read 2
    # # "ab"
    #
    # @param [String] string A string with the data.
    # @return [String] Returns the parameter +string+.
    #
    # @see #read
    def write( string )
      if string.bytesize > @size
        raise "Must not write more than #{@size} bytes of memory " +
          "(illegal attempt to write #{string.bytesize} bytes)"
      end
      orig_write string
    end

    private :orig_write

  end

end
