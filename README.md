malloc
======

**Author**:       Jan Wedekind
**Copyright**:    2010
**License**:      GPL

Synopsis
--------

This Ruby extension defines the class {Hornetseye::Malloc}. {Hornetseye::Malloc.new} allows you to allocate memory, using {Hornetseye::Malloc#+} one can do pointer manipulation, and {Hornetseye::Malloc#read} and {Hornetseye::Malloc#write} provide reading Ruby strings from memory and writing Ruby strings to memory.

Installation
------------

To install this Ruby extension, use the following command:

    $ sudo gem install hornetseye-alsa

Alternatively you can build and install the Ruby extension from source as follows:

    $ rake
    $ sudo rake install

Usage
-----

Simply run Interactive Ruby:

    $ irb

You can load the Ruby extension like this:

    require 'rubygems'
    require 'malloc'
    include Hornetseye

See documentation of {Hornetseye::Malloc} on how to use this Ruby extension.

