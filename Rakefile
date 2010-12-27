task :test do
  require "cutest"
  Cutest.run(Dir["test/nest*"])
end

task :default => :test

task :commands do
  require "open-uri"
  require "par"
  require "json"

  file = File.expand_path("lib/nest.rb", File.dirname(__FILE__))
  path = "https://github.com/antirez/redis-doc/raw/master/commands.json"

  commands = JSON.parse(open(path).read).select do |name, command|
    # Skip all DEBUG commands
    next if command["group"] == "server"

    # If the command has no arguments, it doesn't operate on a key
    next if command["arguments"].nil?

    arg = command["arguments"].first

    arg["type"] == "key" ||
      Array(arg["name"]) == ["channel"]
  end

  commands = commands.keys.map { |key| key.downcase.to_sym }

  commands.delete(:mget)

  source = File.read(file).sub(/  METHODS = .+?\n\n/m) do
    Par.new("  METHODS = #{commands.inspect}\n\n", p: 2)
  end

  File.open(file, "w") { |f| f.write source }

  system "git diff --color-words #{file}"
end
