require 'test/unit'
Kernel::require 'malloc'

class TC_Malloc < Test::Unit::TestCase

  def test_new
    assert_nothing_raised { Hornetseye::Malloc.new 32 }
    assert_raise( ArgumentError ) { Hornetseye::Malloc.new }
  end

  def test_read_write
    m = Hornetseye::Malloc.new 6
    m.write 'abcdef'
    assert_equal 'abcdef', m.read( 6 )
    m.write 'ghi'
    assert_equal 'ghidef', m.read( 6 )
    assert_raise( RuntimeError ) { m.read 7 }
    assert_raise( RuntimeError ) { m.write 'abcdefg' }
  end

  def test_plus
    assert_raise( RuntimeError ) { Hornetseye::Malloc.new( 2 ) + ( -1 ) }
    assert_nothing_raised { Hornetseye::Malloc.new( 2 ) + 2 }
    assert_raise( RuntimeError ) { Hornetseye::Malloc.new( 2 ) + 3 }
    m = Hornetseye::Malloc.new 6
    m.write 'abcdef'
    assert_equal 'cde', ( m + 2 ).read( 3 )
    assert_raise( RuntimeError ) { ( m + 2 ).read 5 }
  end

end
