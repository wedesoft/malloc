class String

  unless method_defined? :bytesize

    def bytesize
      size
    end

  end
  
end

class Malloc

  class << self

    alias_method :orig_new, :new

    def new( size )
      retval = orig_new size
      retval.instance_eval { @size = size }
      retval
    end

  end

  attr_reader :size

  alias_method :orig_plus, :+

  def +( offset )
    if offset > @size
      raise "Offset must not be more than #{@size} (but was #{offset})"
    end
    mark, size = self, @size - offset
    retval = orig_plus offset
    retval.instance_eval { @mark, @size = mark, size }
    retval
  end

  alias_method :orig_read, :read

  def read( length )
    raise "Only #{@size} bytes of memory left to read " +
      "(illegal attempt to read #{length} bytes)" if length > @size
    orig_read length
  end

  alias_method :orig_write, :write

  def write( string )
    if string.bytesize > @size
      raise "Must not write more than #{@size} bytes of memory " +
        "(illegal attempt to write #{string.bytesize} bytes)"
    end
    orig_write string
  end

end
