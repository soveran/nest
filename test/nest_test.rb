require File.expand_path("test_helper", File.dirname(__FILE__))

# Creating namespaces.
scope do
  test "return the namespace" do
    n1 = Nest.new("foo")
    assert "foo" == n1
  end

  test "prepend the namespace" do
    n1 = Nest.new("foo")
    assert "foo:bar" == n1["bar"]
  end

  test "work in more than one level" do
    n1 = Nest.new("foo")
    n2 = Nest.new(n1["bar"])
    assert "foo:bar:baz" == n2["baz"]
  end

  test "be chainable" do
    n1 = Nest.new("foo")
    assert "foo:bar:baz" == n1["bar"]["baz"]
  end

  test "accept symbols" do
    n1 = Nest.new(:foo)
    assert "foo:bar" == n1[:bar]
  end

  test "accept numbers" do
    n1 = Nest.new("foo")
    assert "foo:3" == n1[3]
  end
end

# Operating with redis.
scope do
  prepare do
    @redis = Redis.new
    @redis.flushdb
  end

  test "work if no redis instance was passed" do
    n1 = Nest.new("foo")
    n1.set("s1")

    assert "s1" == n1.get
  end

  test "work if a redis instance is supplied" do
    n1 = Nest.new("foo", @redis)
    n1.set("s1")

    assert "s1" == n1.get
  end

  test "pass the redis instance to new keys" do
    n1 = Nest.new("foo", @redis)

    assert @redis.id == n1["bar"].redis.id
  end

  test "PubSub" do
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
