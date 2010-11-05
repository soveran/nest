Gem::Specification.new do |s|
  s.name              = "nest"
  s.version           = "1.0.1"
  s.summary           = "Object Oriented Keys for Redis."
  s.description       = "It is a design pattern in key-value databases to use the key to simulate structure, and Nest can take care of that."
  s.authors           = ["Michel Martens"]
  s.email             = ["michel@soveran.com"]
  s.homepage          = "http://github.com/soveran/nest"
  s.files = ["LICENSE", "README.markdown", "Rakefile", "lib/nest.rb", "nest.gemspec", "test/nest_test.rb", "test/test_helper.rb"]
  s.add_dependency "redis", "~> 2.1"
  s.add_development_dependency "cutest", "~> 0.1"
end
