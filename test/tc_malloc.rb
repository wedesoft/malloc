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

require 'test/unit'
Kernel::require 'malloc'

class TC_Malloc < Test::Unit::TestCase

  Malloc = Hornetseye::Malloc

  def Malloc( *args )
    Hornetseye::Malloc *args
  end

  def test_new
    assert_nothing_raised { Malloc.new 32 }
    assert_nothing_raised { Malloc 32 }
    assert_raise( ArgumentError ) { Malloc.new }
  end

  def test_inspect
    assert_equal 'Malloc(32)', Malloc.new( 32 ).inspect
  end

  def test_to_s
    assert_equal 'Malloc(32)', Malloc.new( 32 ).to_s
  end

  def test_dup
    m = Malloc.new( 3 )
    m.write 'abc'
    m.dup.write 'def'
    assert_equal 'abc', m.read( 3 )
  end

  def test_read_write
    m = Malloc.new 6
    assert_equal 'abcdef', m.write( 'abcdef' )
    assert_equal 'abcdef', m.read( 6 )
    assert_equal 'ghi', m.write( 'ghi' )
    assert_equal 'ghidef', m.read( 6 )
    n = Malloc.new 3
    n.write 'jkl'
    assert_equal n, m.write( n )
    assert_equal 'jkldef', m.read( 6 )
    assert_raise( RuntimeError ) { m.read 7 }
    assert_raise( RuntimeError ) { m.write 'abcdefg' }
    assert_raise( RuntimeError ) { m.write Malloc.new( 7 ) }
  end

  def test_plus
    assert_raise( RuntimeError ) { Malloc.new( 2 ) + ( -1 ) }
    assert_nothing_raised { Malloc.new( 2 ) + 2 }
    assert_raise( RuntimeError ) { Malloc.new( 2 ) + 3 }
    m = Malloc.new 6
    m.write 'abcdef'
    assert_equal 'cde', ( m + 2 ).read( 3 )
    assert_raise( RuntimeError ) { ( m + 2 ).read 5 }
  end

end
