task :test do
  system "cd test && ruby nest_test.rb"
end

task :default => :test

task :commands do
  require "open-uri"
  require "par"

  file = File.expand_path("lib/nest.rb", File.dirname(__FILE__))
  path = "http://dimaion.com/redis/master/keys"

  commands = open(path).read.split("\n")

  source = File.read(file).sub(/  METHODS = .+?\n\n/m) do
    Par.new("  METHODS = #{commands.map(&:to_sym).inspect}\n\n", p: 2)
  end

  File.open(file, "w") { |f| f.write source }

  system "git diff --color-words #{file}"
end
