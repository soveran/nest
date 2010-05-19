class Nest < String
  VERSION = "0.0.4"

  def initialize(key, redis = nil)
    super(key)
    @redis = redis
  end

  def [](key)
    self.class.new("#{self}:#{key}", redis)
  end

  [:append, :blpop, :brpop, :decr, :decrby, :del, :exists, :expire,
  :expireat, :get, :getset, :hdel, :hexists, :hget, :hgetall,
  :hincrby, :hkeys, :hlen, :hmset, :hset, :hvals, :incr, :incrby,
  :lindex, :llen, :lpop, :lpush, :lrange, :lrem, :lset, :ltrim, :move,
  :rename, :renamenx, :rpop, :rpoplpush, :rpush, :sadd, :scard,
  :sdiff, :sdiffstore, :set, :setex, :setnx, :sinter, :sinterstore,
  :sismember, :smembers, :smove, :sort, :spop, :srandmember, :srem,
  :substr, :sunion, :sunionstore, :ttl, :type, :zadd, :zcard,
  :zincrby, :zinterstore, :zrange, :zrangebyscore, :zrank, :zrem,
  :zremrangebyrank, :zremrangebyscore, :zrevrange, :zrevrank, :zscore,
  :zunionstore].each do |meth|
    define_method(meth) do |*args|
      redis.send(meth, self, *args)
    end
  end

private

  def redis
    @redis
  end
end
