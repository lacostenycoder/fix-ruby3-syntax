require 'pry'
require 'active_support/core_ext/string/filters'

@check_files = []
@fixed_files = []
@unmatched_files = []
@ruby_files = Dir.glob(['**.rb', '**.rake']) - ['fix.rb']

@pattern = /\w+\:.*(\n+)?.*\)/

def check_methods(str)
  binding.pry
  chunks = str.partition(/\(|\)/).map(&:squish)
end

def clean_file(filename)
  code_str = File.read(filename)  
  if code_str.match(@pattern)
    check_methods(code_str)  
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
