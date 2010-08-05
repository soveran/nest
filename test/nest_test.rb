require File.expand_path("test_helper", File.dirname(__FILE__))

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
      n1.set("s1")

      assert_equal "s1", n1.get
    end

    should "pass the redis instance to new keys" do
      n1 = Nest.new("foo", @redis)
      n1["bar"].set("s2")

      assert_equal nil, n1.get
      assert_equal "s2", n1["bar"].get
    end

    should "PubSub" do
      foo = Nest.new("foo", @redis)
      listening = false
      message_received = false

      Thread.new do
        while !listening; end
        Nest.new("foo", Redis.new(:db => 15)).publish("")
      end

      foo.subscribe do |on|
        on.message do
          message_received = true

          foo.unsubscribe
        end

        listening = true
      end

      assert message_received
    end
  end
end
