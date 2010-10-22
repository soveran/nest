require "redis"

class Nest < String
  VERSION = "0.0.7"

  METHODS = [:append, :blpop, :brpop, :decr, :decrby, :del, :exists,
  :expire, :expireat, :get, :getset, :hdel, :hexists, :hget, :hgetall,
  :hincrby, :hkeys, :hlen, :hmget, :hmset, :hset, :hsetnx, :hvals,
  :incr, :incrby, :lindex, :linsert, :llen, :lpop, :lpush, :lpushx,
  :lrange, :lrem, :lset, :ltrim, :move, :psubscribe, :publish,
  :punsubscribe, :rename, :renamenx, :rpop, :rpoplpush, :rpush,
  :rpushx, :sadd, :scard, :sdiff, :sdiffstore, :set, :setex, :setnx,
  :sinter, :sinterstore, :sismember, :smembers, :smove, :sort,
  :spop, :srandmember, :srem, :strlen, :subscribe, :substr, :sunion,
  :sunionstore, :ttl, :type, :unsubscribe, :watch, :zadd, :zcard,
  :zcount, :zincrby, :zinterstore, :zrange, :zrangebyscore, :zrank,
  :zrem, :zremrangebyrank, :zremrangebyscore, :zrevrange, :zrevrank,
  :zscore, :zunionstore]

  attr :redis

  def initialize(key, redis = Redis.connect)
    super(key.to_s)
    @redis = redis
  end

  def [](key)
    self.class.new("#{self}:#{key}", redis)
  end

  METHODS.each do |meth|
    define_method(meth) do |*args, &block|
      redis.send(meth, self, *args, &block)
    end
  end
end
