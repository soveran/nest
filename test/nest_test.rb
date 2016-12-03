require_relative "helper"

# Creating namespaces.
scope do
  test "return the namespace" do
    n1 = Nest.new("foo", Redic.new)
    assert "foo" == n1.to_s
  end

  test "prepend the namespace" do
    n1 = Nest.new("foo")
    assert "foo:bar" == n1["bar"].to_s
  end

  test "work in more than one level" do
    n1 = Nest.new("foo")
    n2 = Nest.new(n1["bar"])
    assert "foo:bar:baz" == n2["baz"].to_s
  end

  test "be chainable" do
    n1 = Nest.new("foo")
    assert "foo:bar:baz" == n1["bar"]["baz"].to_s
  end

  test "accept symbols" do
    n1 = Nest.new(:foo)
    assert "foo:bar" == n1[:bar].to_s
  end

  test "accept numbers" do
    n1 = Nest.new("foo")
    assert "foo:3" == n1[3].to_s
  end
end

# Operating with redis.
scope do
  prepare do
    @redis = Redic.new
    @redis.call("FLUSHDB")
  end

  test "work if no redis instance was passed" do
    n1 = Nest.new("foo")
    n1.call("SET", "s1")

    assert "s1" == n1.call("GET")
  end

  test "work if a redis instance is supplied" do
    n1 = Nest.new("foo", @redis)
    n1.call("SET", "s1")

    assert "s1" == n1.call("GET")
  end

  test "pass the redis instance to new keys" do
    n1 = Nest.new("foo", @redis)

    assert @redis.object_id == n1["bar"].redis.object_id
  end
end
