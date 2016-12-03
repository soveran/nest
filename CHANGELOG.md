## 3.0.0

- Use `call` for interacting with Redis

  In previous versions, all the allowed Redis commands were defined
  in Ruby. The downside of that approach was the fact Nest had to
  be kept in sync with Redis as new commands were added to the
  later. The new approach is more verbose, but the maintenance is
  now close to non-existent.
