# Copyright (c) 2010 Michel Martens
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
require "redic"

class Nest
  def initialize(ns, rc = Redic.new)
    @ns = ns.to_s
    @rc = rc
  end

  def [](key)
    Nest.new("#{@ns}:#{key}", @rc)
  end

  def redis
    @rc
  end

  def hash
    @ns.hash
  end

  def to_ary
    nil
  end

  def to_str
    @ns
  end

  alias to_s to_str
  alias to_a to_ary

  def to_json(*args)
    @ns.to_json(*args)
  end

  def call(command, *args)
    @rc.call(command, to_s, *args)
  end

  def call!(command, *args)
    @rc.call!(command, to_s, *args)
  end

  def queue(command, *args)
    @rc.queue(command, to_s, *args)
  end

  def commit
    @rc.commit
  end

  def inspect
    @ns.inspect
  end

  def method_missing(m, *args)
    call(m, *args)
  end
end
