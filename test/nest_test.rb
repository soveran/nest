require File.join(File.dirname(__FILE__), "test_helper")

class TestNest < Test::Unit::TestCase
  should "return the namespace" do
    n1 = Nest.new("foo")
    assert_equal "foo", n1
  end

  should "prepend the namespace" do
    n1 = Nest.new("foo")
    assert_equal "foo:bar", n1["bar"]
  end

  should "work in more than one level" do
    n1 = Nest.new("foo")
    n2 = Nest.new(n1["bar"])
    assert_equal "foo:bar:baz", n2["baz"]
  end

  should "be chainable" do
    n1 = Nest.new("foo")
    assert_equal "foo:bar:baz", n1["bar"]["baz"]
  end

  should "accept symbols" do
    n1 = Nest.new(:foo)
    assert_equal "foo:bar", n1[:bar]
  end

  should "accept numbers" do
    n1 = Nest.new("foo")
    assert_equal "foo:3", n1[3]
  end
end
