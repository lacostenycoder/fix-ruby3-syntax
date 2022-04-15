require 'pry'
require 'json'
require 'active_support/core_ext/string/filters'

@check_files = []
@fixed_files = []
@unmatched_files = []
@ruby_files = Dir.glob(['**.rb', '**.rake']) - ['fix.rb']

@pattern = /\w+\:.*(\n+)?.*\)/

def update_to_explicit_hash(string)
  # Find any string between parentheses.
  matches = string.scan /(?<=\()[^()]+(?=\))/

  matches.each do |match_string|
    stripped = match_string.squish

    # Check if hash string and if it isn't prefixed with a bracket.
    if (stripped.chars.first != '{' and stripped.match? /:|=>/)
      new_string = "{#{match_string}}"
      if valid_hash?(new_string.squish)
        string = string.gsub(match_string, new_string)
      end
    end
  end

  string
end

def valid_hash?(string)
  begin
    #=> "{:key_1=>true,\"key_2\":false}"
    string.gsub!(/(\w+):\s*([^},])/, '"\1":\2')
    #=> "{\"key_1\":true,\"key_2\":false}"
    string.gsub!(/:(\w+)\s*=>/, '"\1":')
    #strip string interpolation
    # string.gsub!(/\#\{+(?<=\#\{)[^()]+(?=\}\")+\}/, '')
    my_hash = JSON.parse(string, {symbolize_names: true})
    #=> {:key_1=>true, :key_2=>false}
    my_hash.is_a? Hash
  rescue JSON::ParserError
    binding.pry
    # string.gsub!(/\#\{+(?<=\#\{)[^()]+(?=\}\")+\}/, '')
    false
  end
  true
end

def clean_file(filename)
  code_str = File.read(filename)
  if code_str.match(@pattern)
    File.write(filename, update_to_explicit_hash(code_str))
    @check_files << filename
  else
    @unmatched_files << filename
  end
end

def report_results
  puts "These need checking:"
  puts @check_files
  puts "Total: #{@check_files.count}"
  puts "These are ok"
  puts @unmatched_files
  puts "Total: #{@unmatched_files.count}"
end

@ruby_files.each do |file|
  clean_file(file)
end

report_results