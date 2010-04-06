#! /usr/bin/env ruby

class Nest < String
  def [](key)
    self.class.new("#{self}:#{key}")
  end
end
