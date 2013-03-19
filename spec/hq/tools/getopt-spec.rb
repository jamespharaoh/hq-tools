require "tempfile"

require "hq/tools/getopt"

module HQ
module Tools
describe Getopt do

	def go expect, args, spec

		ret, remain =
			Getopt.process args, spec

		ret.should == expect

	end

	def go_error args, spec, message

		Tempfile.open "getopt-test" do |tmp|

			$stderr.reopen tmp.path, "w"

			expect {
				Getopt.process args, spec
			}.to raise_error GetoptError

			$stderr.flush

			File.read(tmp.path).chomp.should == "#{$0}: #{message}"

		end

	end

	# ---------------------------------------- required

	context "with a required option" do

		before do
			@spec = [ { name: :arg_0, required: true } ]
		end

		it "accepts a value" do
			args = [ "--arg-0", "arg_0_value" ]
			expect = { :arg_0 => "arg_0_value" }
			go expect, args, @spec
		end

		it "errors if the option is not provided" do
			args = [ ]
			go_error args, @spec, "option '--arg-0' is required"
		end

		it "errors if the option has no value" do
			args = [ "--arg-0" ]
			go_error args, @spec, "option `--arg-0' requires an argument"
		end

	end

	# ---------------------------------------- required with regex

	context "with a required regex" do

		before do
			@spec = [ { name: :arg_0, required: true, regex: /[abc]{3}/ } ]
		end

		it "accepts a matching value" do
			args = [ "--arg-0", "abc" ]
			expect = { :arg_0 => "abc" }
			go expect, args, @spec
		end

		it "errors if the option is not provided" do
			args = [ ]
			go_error args, @spec, "option '--arg-0' is required"
		end

		it "errors if the option has no value" do
			args = [ "--arg-0" ]
			go_error args, @spec, "option `--arg-0' requires an argument"
		end

		it "errors if the value does not match" do
			args = [ "--arg-0", "abcd" ]
			go_error args, @spec, "option '--arg-0' is invalid: abcd"
		end

	end

	# ---------------------------------------- conversions

	context "with a required integer conversion" do

		before do
			@spec = [
				{ name: :arg_0,
					required: true,
					regex: /[0-9]+/,
					convert: :to_i }
			]
		end

		it "accepts a valid value" do
			args = [ "--arg-0", "123" ]
			expect = { :arg_0 => 123 }
			go expect, args, @spec
		end

	end

	context "with an optional integer conversion" do

		before do
			@spec = [ {
				name: :arg_0,
				regex: /[0-9]+/,
				convert: :to_i,
			} ]
		end

		it "accepts a valid value" do
			args = [ "--arg-0", "123" ]
			expect = { :arg_0 => 123 }
			go expect, args, @spec
		end

		it "uses nil if the option is not provided" do
			args = [ ]
			expect = { :arg_0 => nil }
			go expect, args, @spec
		end

	end

	context "with an optional integer conversion with default" do

		before do
			@spec = [ {
				name: :arg_0,
				default: 10,
				regex: /[0-9]+/,
				convert: :to_i,
			} ]
		end

		it "accepts a valid value" do
			args = [ "--arg-0", "123" ]
			expect = { :arg_0 => 123 }
			go expect, args, @spec
		end

		it "uses the default if the option is not provided" do
			args = [ ]
			expect = { :arg_0 => 10 }
			go expect, args, @spec
		end

	end

	# ---------------------------------------- optional

	context "optional without default" do

		before do
			@spec = [ {
				name: :arg_0,
			} ]
		end

		it "accepts if the option is provided" do
			args = [ "--arg-0", "arg_0_value" ]
			expect = { :arg_0 => "arg_0_value" }
			go expect, args, @spec
		end

		it "uses nil if the option is not provided" do
			args = [ ]
			expect = { :arg_0 => nil }
			go expect, args, @spec
		end

	end

	context "optional with default" do

		before do
			@spec = [ {
				name: :arg_0,
				default: "default_0",
			} ]
		end

		it "accepts if the option is provided" do
			args = [ "--arg-0", "value_0" ]
			expect = { :arg_0 => "value_0" }
			go expect, args, @spec
		end

		it "uses the default if the option is not provided" do
			args = [ ]
			expect = { :arg_0 => "default_0" }
			go expect, args, @spec
		end

	end

	# ---------------------------------------- multi

	context "multi optional" do

		before do
			@spec = [ {
				name: :arg0,
				multi: true,
			} ]
		end

		it "accepts if the option is not provided" do
			args = %W[ ]
			expect = { :arg0 => [ ] }
			go expect, args, @spec
		end

		it "accepts if the option is provided once" do
			args = %W[ --arg0 arg0-value0 ]
			expect = { :arg0 => [ "arg0-value0" ] }
			go expect, args, @spec
		end

		it "accepts if the option is provided multiple times" do
			args = %W[ --arg0 arg0-value0 --arg0 arg0-value1 ]
			expect = { :arg0 => [ "arg0-value0", "arg0-value1" ] }
			go expect, args, @spec
		end

	end

	context "multi required" do

		before do
			@spec = [ {
				name: :arg0,
				multi: true,
				required: true,
			} ]
		end

		it "errors if the option is not provided" do
			args = %W[ ]
			expect = { :arg0 => [ "arg0-value0", "arg0-value1" ] }
			go_error args, @spec, "option '--arg0' is required"
		end

		it "accepts if the option is provided" do
			args = %W[ --arg0 arg0-value0 --arg0 arg0-value1 ]
			expect = { :arg0 => [ "arg0-value0", "arg0-value1" ] }
			go expect, args, @spec
		end

	end

	# ---------------------------------------- boolean

	context "boolean" do

		before do
			@spec = [ {
				name: :arg0,
				boolean: true,
			} ]
		end

		it "uses false if the option is not provided" do
			args = %W[ ]
			expect = { :arg0 => false }
			go expect, args, @spec
		end

		it "uses true if the option is provided" do
			args = %W[ --arg0 ]
			expect = { :arg0 => true }
			go expect, args, @spec
		end

	end

	# ---------------------------------------- switch

	context "switch without default" do

		before do
			@spec = [ {
				name: :arg0,
				options: [ :opt0, :opt1 ],
			} ]
		end

		it "accepts if the option is not provided" do
			args = %W[ ]
			expect = { :arg0 => nil }
			go expect, args, @spec
		end

		it "accepts if the option is provided" do
			args = %W[ --opt1 ]
			expect = { :arg0 => :opt1 }
			go expect, args, @spec
		end

	end

	context "switch with default" do

		before do
			@spec = [ {
				name: :arg0,
				default: :opt0,
				options: [ :opt1 ],
			} ]
		end

		it "uses the default if the option is not provided" do
			args = %W[ ]
			expect = { :arg0 => :opt0 }
			go expect, args, @spec
		end

		it "accepts if the option is provided" do
			args = %W[ --opt1 ]
			expect = { :arg0 => :opt1 }
			go expect, args, @spec
		end

	end

end
end
end
