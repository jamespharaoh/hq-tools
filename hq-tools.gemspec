#!/usr/bin/env ruby

hq_tools_dir =
	File.expand_path "..", __FILE__

$LOAD_PATH.unshift "#{hq_tools_dir}/ruby" \
	unless $LOAD_PATH.include? "#{hq_tools_dir}/ruby"

Gem::Specification.new do
	|spec|

	spec.name = "hq-tools"
	spec.version = "0.0.0"
	spec.platform = Gem::Platform::RUBY
	spec.authors = [ "James Pharaoh" ]
	spec.email = [ "james@phsys.co.uk" ]
	spec.homepage = "https://github.com/jamespharaoh/hq-tools"
	spec.summary = "HQ tools"
	spec.description = "HQ common library"
	spec.required_rubygems_version = ">= 1.3.6"

	spec.rubyforge_project = "hq-tools"

	spec.add_dependency "rake", ">= 10.0.3"

	spec.add_development_dependency "cucumber", ">= 1.2.1"
	spec.add_development_dependency "rspec", ">= 2.12.0"
	spec.add_development_dependency "rspec_junit_formatter"
	spec.add_development_dependency "simplecov"

	spec.files = Dir[

		"features/**/*.feature",
		"features/**/*.rb",

		"lib/**/*.rb",

	]

	spec.test_files = []

	spec.executables = []

	spec.require_paths = [ "lib" ]

end

