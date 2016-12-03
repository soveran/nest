Gem::Specification.new do |s|
  s.name              = "nest"
  s.version           = "3.0.0"
  s.summary           = "Object-oriented keys for Redis."
  s.description       = "It is a design pattern in key-value databases to use the key to simulate structure, and Nest can take care of that."
  s.licenses          = ["MIT"]
  s.authors           = ["Michel Martens"]
  s.email             = ["michel@soveran.com"]
  s.homepage          = "http://github.com/soveran/nest"

  s.add_dependency "redic"

  s.files = Dir[
    "LICENSE",
    "README.md",
    "Rakefile",
    "lib/**/*.rb",
    "*.gemspec",
    "test/*.*"
  ]

  s.add_development_dependency "cutest"
end
