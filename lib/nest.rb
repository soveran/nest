#! /usr/bin/env ruby

class Nest < String
  VERSION = "0.0.2"

  def [](key)
    self.class.new("#{self}:#{key}")
  end
end
