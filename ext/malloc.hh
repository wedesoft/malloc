/* HornetsEye - Computer Vision with Ruby
   Copyright (C) 2006, 2007, 2008, 2009   Jan Wedekind

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>. */
#ifndef MALLOC_HH
#define MALLOC_HH

#include "rubyinc.hh"

class Malloc
{
public:
  static VALUE cRubyClass;
  static VALUE init( VALUE rbModule );
  static VALUE mallocNew( VALUE rbClass, VALUE rbSize );
  static VALUE mallocPlus( VALUE rbSelf, VALUE rbOffset );
  static VALUE mallocRead( VALUE rbSelf, VALUE rbLength );
  static VALUE mallocWrite( VALUE rbSelf, VALUE rbString );
};

#endif
