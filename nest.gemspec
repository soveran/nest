Gem::Specification.new do |s|
  s.name              = "nest"
  s.version           = "3.0.0"
  s.summary           = "Object-oriented keys for Redis."
  s.description       = "It is a design pattern in key-value databases to use the key to simulate structure, and Nest can take care of that."
  s.license           = "MIT"
  s.authors           = ["Michel Martens"]
  s.email             = ["michel@soveran.com"]
  s.homepage          = "http://github.com/soveran/nest"

  s.files = `git ls-files`.split("\n")
  
  s.add_dependency "redic"
  s.add_development_dependency "cutest"
end
