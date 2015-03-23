require "redic"

class Nest < String
  METHODS = [:append, :bitcount, :blpop, :brpop, :brpoplpush, :decr,
  :decrby, :del, :dump, :exists, :expire, :expireat, :get, :getbit,
  :getrange, :getset, :hdel, :hexists, :hget, :hgetall, :hincrby,
  :hincrbyfloat, :hkeys, :hlen, :hmget, :hmset, :hset, :hsetnx, :hvals,
  :incr, :incrby, :incrbyfloat, :lindex, :linsert, :llen, :lpop,
  :lpush, :lpushx, :lrange, :lrem, :lset, :ltrim, :move, :persist,
  :pexpire, :pexpireat, :psetex, :pttl, :publish, :rename, :renamenx,
  :restore, :rpop, :rpoplpush, :rpush, :rpushx, :sadd, :scard,
  :sdiff, :sdiffstore, :set, :setbit, :setex, :setnx, :setrange,
  :sinter, :sinterstore, :sismember, :smembers, :smove, :sort, :spop,
  :srandmember, :srem, :strlen, :sunion, :sunionstore,
  :ttl, :type, :watch, :zadd, :zcard, :zcount,
  :zincrby, :zinterstore, :zrange, :zrangebyscore, :zrank, :zrem,
  :zremrangebyrank, :zremrangebyscore, :zrevrange, :zrevrangebyscore,
  :zrevrank, :zscore, :zunionstore]

  attr :redis

  def initialize(key, redis = Redic.new)
    super(key.to_s)
    @redis = redis
  end

  def [](key)
    self.class.new("#{self}:#{key}", redis)
  end

  METHODS.each do |meth|
    define_method(meth) do |*args, &block|
      redis.call(meth, self, *args, &block)
    end
  end
end
