## 3.2.0

- Add call!, queue and commit commands.

## 3.1.2

- Define to_json

  This solves issues that arise when a third party library redefines
  `to_json` for all objects.

## 3.1.1

- Define to_a and to_ary

  These method definitions are needed for interacting with array-casting
  operations like Array#flatten and Array().

## 3.1.0

- Forward missing methods to Redis as commands

## 3.0.0

- Use `call` for interacting with Redis

  In previous versions, all the allowed Redis commands were defined
  in Ruby. The downside of that approach was the fact Nest had to
  be kept in sync with Redis as new commands were added to the
  later. The new approach is more verbose, but the maintenance is
  now close to non-existent.
