Nest
====

Generate nested namespaced keys for key-value databases.

Description
-----------

If you are familiar with databases like
[Redis](http://code.google.com/p/redis) and libraries like [Ohm](http://ohm.keyvalue.org) or
[redis-namespace](http://github.com/defunkt/redis-namespace), you
already know how important it is to craft the keys that will hold the
data.

    >> @redis.set "event:3:name", "Redis Meetup"
    >> @redis.get "event:3:name"
    => "Redis Meetup"

It is a design pattern in key-value databases to use the key to simulate
structure, and you can read more about this in the [Twitter case
study](http://code.google.com/p/redis/wiki/TwitterAlikeExample).

Nest helps you generate those keys by providing chainable namespaces:

    >> event = Nest.new("event")
    >> @redis.set event[3][:name], "Redis Meetup"
    >> @redis.get event[3][:name]
    => "Redis Meetup"

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

    >> event = Nest.new("event")
    => "event"

    >> redis = Redis.new
    => #<Redis::Client...>

    >> id = redis.incr(event)
    => 1

    >> redis.set event[id][:name], "Redis Meetup"
    => "OK"

    >> redis.get event[id][:name]
    => "Redis Meetup"

    >> meetup = event[id]
    => "event:1"

    >> redis.get meetup[:name]
    => "Redis Meetup"

Differences with redis-namespace
-------------------------------

[redis-namespace](http://github.com/defunkt/redis-namespace) wraps Redis
and translates the keys back and forth transparently.

Use redis-namespace when you want all your application keys to live in a
different scope.

Use Nest when you want to use the keys to represent structure.

Differences with Ohm
-------------------

[Ohm](http://ohm.keyvalue.org) lets you map Ruby objects to Redis with
little effort. It not only alleviates you from the pain of generating
keys for each object, but also helps you when dealing with references
between objects.

Use Ohm when you want to use Redis as your database.

Use Nest when mapping objects with Ohm is not possible.

Installation
------------

    $ sudo gem install nest

License
-------

Copyright (c) 2010 Michel Martens

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
