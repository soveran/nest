require "redic"

class Nest < String
  METHODS = [:append, :bitcount, :bitfield, :bitpos, :blpop, :brpop,
    :brpoplpush, :decr, :decrby, :del, :dump, :exists, :expire,
    :expireat, :geoadd, :geohash, :geopos, :geodist, :georadius,
    :georadiusbymember, :get, :getbit, :getrange, :getset, :hdel,
    :hexists, :hget, :hgetall, :hincrby, :hincrbyfloat, :hkeys, :hlen,
    :hmget, :hmset, :hset, :hsetnx, :hstrlen, :hvals, :incr, :incrby,
    :incrbyfloat, :lindex, :linsert, :llen, :lpop, :lpush, :lpushx,
    :lrange, :lrem, :lset, :ltrim, :move, :persist, :pexpire, :pexpireat,
    :pfadd, :pfcount, :pfmerge, :psetex, :pttl, :publish, :rename,
    :renamenx, :restore, :rpop, :rpoplpush, :rpush, :rpushx, :sadd,
    :scard, :sdiff, :sdiffstore, :set, :setbit, :setex, :setnx,
    :setrange, :sinter, :sinterstore, :sismember, :smembers, :smove,
    :sort, :spop, :srandmember, :srem, :strlen, :subscribe, :sunion,
    :sunionstore, :touch, :ttl, :type, :unsubscribe, :watch, :zadd,
    :zcard, :zcount, :zincrby, :zinterstore, :zlexcount, :zrange,
    :zrangebylex, :zrevrangebylex, :zrangebyscore, :zrank, :zrem,
    :zremrangebylex, :zremrangebyrank, :zremrangebyscore, :zrevrange,
    :zrevrangebyscore, :zrevrank, :zscore, :zunionstore, :sscan,
    :hscan, :zscan]

  attr :redis

  def initialize(key, redis = Redic.new)
    super(key.to_s)
    @redis = redis
  end

  def [](key)
    self.class.new("#{self}:#{key}", redis)
  end

  METHODS.each do |meth|
    define_method(meth) do |*args|
      redis.call(meth, self, *args)
    end
  end
end
