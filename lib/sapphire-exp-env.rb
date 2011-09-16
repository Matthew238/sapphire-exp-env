class Sapphire
  require 'rubygems'
  require 'thor'
  require 'open-uri'
  class Command < Thor

    desc 'generates args1 [args2] ...', 'Generates necessary file(s) for Sapphire'
    long_desc <<-D
      This command enerates necessary file(s) for Sapphire.
      Subcommands below:
      rvm instructions ... genreates instruction.rb from insns.def
      ...
    D
    def generates(*args)
      name = args.shift
      case name
      when /rvm/
        object = args.shift
        case object
        when /instructions/
          create_instruction_class
        else
        end
      end
    end

    private

    def create_instruction_class
      url = 'https://raw.github.com/ruby/ruby/trunk/insns.def'
      file_name = url.split(/\//).last
      begin
        open(url) do |source|
          open(file_name, "w+b") do |output|
            output.print source.read
          end
        end
      rescue
        raise "retrieving error(insns.def)"
      end
      open("instructions.rb", "w+b") do |output|
        output.print put_instruction_class_header
        output.print put_instruction_class_insn file_name, output
        output.print put_instruction_class_footer    
      end
    end
    
    def put_instruction_class_header
      return <<-EOL2
class RubyVM
  class InstructionSequence
    class Instruction
      InsnID2NO = {
      EOL2
    end

    def put_instruction_class_insn(file_name, output)
      open(file_name) {|file|
        ino = -1 # initial instruction no
        while line = file.gets
          if /DEFINE_INSN/ =~ line
            iname = file.gets.chop
            if ino != -1
              output.print <<-"EOL1"
        :#{iname} => #{ino},
              EOL1
            end
            ino += 1
          end
        end
      }
    end

    def put_instruction_class_footer
      return <<-EOL3
      }
      def self.id2insn_no id
        if InsnID2NO.has_key? id
          InsnID2NO[id]
        end
      end
    end
  end
end
      EOL3
    end    

  end
end
