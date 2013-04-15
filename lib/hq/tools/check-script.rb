module HQ
module Tools
class CheckScript

	attr_accessor :args
	attr_accessor :status
	attr_accessor :stdout
	attr_accessor :stderr

	def initialize
		@name = "Unnamed"
		@messages = []
		@critical = false
		@warning = false
		@unknown = false
		@performances = []
		@postscript = []
		@stdout = $stdout
		@stderr = $stderr
	end

	def main

		process_args

		begin
			prepare
			perform_checks
		rescue => exception

			message = "%s: %s" % [
				exception.class,
				exception.message,
			]

			critical message

			@postscript << message
			@postscript << exception.backtrace

		end

		perform_output

	end

	def prepare
	end

	def perform_output

		str = StringIO.new

		str.print @name, " "

		if @critical
			str.print "CRITICAL"
		elsif @warning
			str.print "WARNING"
		elsif @unknown
			str.print "UNKNOWN"
		else
			str.print "OK"
		end

		str.print ": "

		str.print @messages.join(", ")

		unless @performances.empty?
			str.print " | "
			str.print @performances.join(" ")
		end

		str.print "\n"

		@stdout.print str.string

		@postscript.each do
			|postscript|
			@stderr.puts postscript
		end

	end

	def message string
		@messages << string
	end

	def critical string
		@messages << string
		@critical = true
	end

	def warning string
		@messages << string
		@warning = true
	end

	def unknown string
		@messages << string
		@unknown = true
	end

	def performance name, value, options = {}
		parts = []
		parts[0] = "%s%s" % [ value, options[:units] ]
		parts[1] = options[:warning].to_s if options[:warning]
		parts[2] = options[:critical].to_s if options[:critical]
		parts[3] = options[:minimum].to_s if options[:minimum]
		parts[4] = options[:maximum].to_s if options[:maximum]
		name = "'#{name.gsub "'", "''"}'" if name =~ /[ ']/
		@performances << "%s=%s" % [ name, parts.join(";") ]
	end

end
end
end
