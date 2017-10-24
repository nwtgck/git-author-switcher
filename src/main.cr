require "yaml"

AUTHOR_YAML_PATH = File.join(ENV["HOME"], ".git-authors.yaml")


class Author
  YAML.mapping(
    id: String,
    name: String,
    email: String
  )
end

# (from: https://github.com/crystal-lang/crystal/issues/3238)
class Authors < Array(Author)
end

# Run command with p
def system_with_echo(cmd_str : String): Bool
  puts("> #{cmd_str}")
  system(cmd_str)
end

# Find authors by uncomplete ID
def smart_find(authors : Authors, uncomplete_id : String): Array(Author)
  authors.select{|author|
    author.id.starts_with?(uncomplete_id)
  }
end


# ID is not specified
if ARGV.size != 1
  puts ("Usage: chauthor <id>")
  exit 1
end

# Get ID from a command argument
uncomplete_id = ARGV[0]

if !File.exists?(AUTHOR_YAML_PATH)
  STDERR.puts("Error: '#{AUTHOR_YAML_PATH}' not found'")
  exit 1
end


begin
  authors = Authors.from_yaml(File.read(AUTHOR_YAML_PATH))
rescue YAML::ParseException
  STDERR.puts("Error: Wrong format '#{AUTHOR_YAML_PATH}' ")
  exit 1
end

candidates = smart_find(authors, uncomplete_id)
#
if(candidates.size == 0)
  STDERR.puts("Error: There isn't any matching author with '#{uncomplete_id}'")
  exit 1
elsif(candidates.size != 1)
  STDERR.puts("Error: Duplicate ids: #{candidates.map{|a| a.name}.join(" and ")} ")
  exit 1
end

author = candidates.first

# Run commands
puts("Run:")
if !system_with_echo("git config user.name '#{author.name}'")
  exit 1
end
if !system_with_echo("git config user.email '#{author.email}'")
  exit 1
end
puts()

# Confirmation of git config
puts("Confirmation:")
system_with_echo("git config --local --list")
