require "yaml"
require "option_parser"


AUTHOR_YAML_PATH = File.join(ENV["HOME"], ".git-authors.yaml")


enable_list_option  = false
enable_unset_option = false

OptionParser.new do |opt|
  opt.banner = "chauthor - Author switcher for git"
  opt.on("-l",  "--list",   "List all authors")   { |v| enable_list_option  = v }
  opt.on("-u",  "--unset",  "Unset author on git config") { |v| enable_unset_option  = v }  
  opt.on("-h", "--help", "Show this help") {
    puts(opt)
    # Exit program
    exit(0)
  }
end.parse!

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

# If list-option is enable
if enable_list_option
  # Calc max ID length
  max_id_size  = authors.map{|a| a.id.size}.max

  # Calc max name length
  max_name_size = authors.map{|a| a.name.size}.max

  # List authors
  puts("Authors in '#{AUTHOR_YAML_PATH}':")
  authors.each.with_index(1){|a, i|
    spaces_after_id    = " " * (max_id_size   - a.id.size)
    spaces_after_name  = " " * (max_name_size - a.name.size)
    puts("#{i}. id: '#{a.id}',#{spaces_after_id} name: '#{a.name}',#{spaces_after_name} email: '#{a.email}'")
  }
  # Exit program
  exit(0)
end


# If unset-option is enable
if enable_unset_option
  puts("Run:")
  if system_with_echo("git config --local --unset user.name")
    if system_with_echo("git config --local --unset user.email")  
    end
  end
  
  puts()

  # Confirmation of git config
  puts("Confirmation:")
  system_with_echo("git config --local --list")
  exit(0)
end

# ID is not specified
if ARGV.size != 1
  puts ("Usage: chauthor <id>")
  exit 1
end

# Get ID from a command argument
uncomplete_id = ARGV[0]


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
if system_with_echo("git config user.name '#{author.name}'")
  if system_with_echo("git config user.email '#{author.email}'")
  end
end

puts()

# Confirmation of git config
puts("Confirmation:")
system_with_echo("git config --local --list")
