Nest
====

Object Oriented Keys for Redis.

Description
-----------

If you are familiar with databases like [Redis](http://redis.io)
and libraries like [Ohm](http://ohm.keyvalue.org) you already know how
important it is to craft the keys that will hold the data.

    >> redis = Redic.new
    >> redis.call("SADD", "event:3:attendees", "Albert")
    >> redis.call("SMEMBERS", "event:3:attendees")
    => ["Albert"]

It is a design pattern in key-value databases to use the key to simulate
structure, and you can read more about this in the [case study for a
Twitter clone](http://redis.io/topics/twitter-clone).

Nest helps you generate those keys by providing chainable namespaces that are
already connected to Redis:

    >> event = Nest.new("event")
    >> event[3][:attendees].sadd("Albert")
    >> event[3][:attendees].smembers
    => ["Albert"]

Usage
-----

To create a new namespace:

    >> ns = Nest.new("foo")
    => "foo"

    >> ns["bar"]
    => "foo:bar"

    >> ns["bar"]["baz"]["qux"]
    => "foo:bar:baz:qux"

And you can use any object as a key, not only strings:

    >> ns[:bar][42]
    => "foo:bar:42"

In a more realistic tone, lets assume you are working with Redis and
dealing with events:

    >> events = Nest.new("events")
    => "events"

    >> id = events[:id].incr
    => 1

    >> events[id][:attendees].sadd("Albert")
    => "OK"

    >> meetup = events[id]
    => "events:1"

    >> meetup[:attendees].smembers
    => ["Albert"]

Supplying your existing Redis instance
--------------------------------------

You can supply a [Redic](https://github.com/amakawa/redic) instance as
a second parameter. If you don't, a default instance is created for you:

    >> redis = Redic.new
    => #<Redic:0x007fa640845f10 ...>

    >> users = Nest.new("users", redis)
    => "users"

    >> id = users[:id].incr
    => 1

    >> users[id].hset(:name, "Albert")
    => "OK"

`Nest` objects respond to `redis` and return a `Redic` instance. It is
automatically reused when you create a new namespace, and you can reuse it when
creating a new instance of Nest:

    >> events = Nest.new("events", meetup.redis)
    => "events"

    >> events.sadd(meetup)
    => true

    >> events.sismember(meetup)
    => true

    >> events.smembers
    => ["events:1"]

    >> events.del
    >> true

Nest allows you to execute all the Redis commands that expect a key as the
first parameter.

Differences with redis-namespace
--------------------------------

[redis-namespace](http://github.com/defunkt/redis-namespace) wraps Redis
and translates the keys back and forth transparently.

Use redis-namespace when you want all your application keys to live in a
different scope.

Use Nest when you want to use the keys to represent structure.

Tip: instead of using redis-namespace, it is recommended that you run a
different instance of `redis-server`. Translating keys back and forth is not
only delicate, but unnecessary and counterproductive.

Differences with Ohm
--------------------

[Ohm](http://ohm.keyvalue.org) lets you map Ruby objects to Redis with
little effort. It not only alleviates you from the pain of generating
keys for each object, but also helps you when dealing with references
between objects.

Use Ohm when you want to use Redis as your database.

Use Nest when mapping objects with Ohm is not possible or overkill.

Tip: Ohm uses Nest internally to deal with keys. Having a good knowledge
of Nest will let you extend Ohm to suit your needs.

Installation
------------

    $ gem install nest

License
-------

Copyright (c) 2010-2015 Michel Martens & Damian Janowski

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
