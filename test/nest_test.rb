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

# Operating with Redis.
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

  test "execute multiple redis commands in transaction" do
    n1 = Nest.new("foo", @redis)

    n1.redis.queue("MULTI")
    n1.queue("APPEND", "foo")
    n1.queue("APPEND", "bar")
    n1.redis.queue("EXEC")
    n1.commit

    assert_equal "foobar", n1.get
  end

  test "raise error on redis failure when calling with bang" do
    n1 = Nest.new("foo", @redis)
    v1 = "234293482390480948029348230948"

    n1.call("SET", v1)

    assert_equal v1, n1.call!("GET")
    assert_raise RuntimeError do
      n1.call!("DECR")
    end
  end
end


# Operating with Redis with dynamic methods.
scope do
  prepare do
    @redis = Redic.new
    @redis.call("FLUSHDB")
  end

  test "relay missing methods as Redis commands" do
    n1 = Nest.new("foo")
    n1.set("s1")

    assert "s1" == n1.get
  end
end

# Operations that call to_a and to_ary
scope do
  test "interaction with array-casting operations" do
    n1 = Nest.new("foo")

    assert_equal [n1], [n1].flatten
    assert_equal [n1],  Array(n1)
  end
end

# Operations that call to_str and to_ary
scope do
  test "interaction with string-casting operations" do
    n1 = Nest.new("foo")
    s1 = "bar"

    s2 = s1 + n1

    assert_equal "barfoo", s1 + n1
  end

  test "interaction with array-casting operations" do
    n1 = Nest.new("foo")

    assert_equal [n1], [n1].flatten
    assert_equal [n1],  Array(n1)
  end
end
