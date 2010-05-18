require File.join(File.dirname(__FILE__), "test_helper")

class TestNest < Test::Unit::TestCase
  context "creating namespaces" do
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

  context "operating with redis" do
    require "redis"

    setup do
      @redis = Redis.new :db => 15
      @redis.flushdb
    end

    should "raise if no redis instance was passed" do
      n1 = Nest.new("foo")

      assert_raises NoMethodError do
        n1.set("s1")
      end
    end

    should "work if a redis instance is supplied" do
      n1 = Nest.new("foo", @redis)
      n1.set("s")
      n1.append("1")

      assert_equal "s1", n1.get
      assert_equal "string", n1.type
      assert_equal true, n1.exists
    end
  end
end
