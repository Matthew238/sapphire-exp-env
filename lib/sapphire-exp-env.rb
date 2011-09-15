class Sapphire
  require 'rubygems'
  require 'thor'
  require 'open-uri'
  class Command < Thor
  
    desc 'hello', 'Hello, World!'
    def hello
      puts 'Hello, Wolrd...'
    end

    desc 'generates NAME [VALUES]', 'Generates necessary files for Sapphire'
    long_desc <<-D
      Generates necessary files for Sapphire...
      rvm instructions
      rvm ...
    D
    def generates(*args)
      name = args.shift
      case name
      when /rvm/
        object = args.shift
        case object
        when /instructions/
          url = 'https://raw.github.com/ruby/ruby/trunk/insns.def'
          filename = url.split(/\//).last
          open(url) do |source|
            open(filename, "w+b") do |output|
              output.print source.read
            end
          end
        else
        end
      end
    end
  end
end
