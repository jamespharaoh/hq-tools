#!/usr/bin/env ruby

$hq_project_path =
	File.expand_path "..", __FILE__

module ::HQ
	def self.project_param name
		File.read("#{$hq_project_path}/.hq-dev/#{name}").strip
	end
end

$hq_project_name =
	HQ.project_param "name"

$hq_project_ver =
	HQ.project_param "version"

$hq_project_full =
	HQ.project_param "full-name"

$hq_project_desc =
	HQ.project_param "description"

Gem::Specification.new do
	|spec|

	spec.name = $hq_project_name
	spec.version = $hq_project_ver
	spec.platform = Gem::Platform::RUBY
	spec.authors = [ "James Pharaoh" ]
	spec.email = [ "james@phsys.co.uk" ]
	spec.homepage = "https://github.com/jamespharaoh/#{$hq_project_name}"
	spec.summary = $hq_project_full
	spec.description = $hq_project_desc
	spec.required_rubygems_version = ">= 1.3.6"

	spec.rubyforge_project = $hq_project_name

	spec.add_development_dependency "cucumber", ">= 1.2.1"
	spec.add_development_dependency "rake", ">= 10.0.3"
	spec.add_development_dependency "rspec", ">= 2.12.0"
	spec.add_development_dependency "rspec_junit_formatter"
	spec.add_development_dependency "simplecov"

	spec.files = Dir[
		"lib/**/*.rb",
	]

	spec.test_files = Dir[
		"features/**/*.feature",
		"features/**/*.rb",
		"spec/**/*-spec.rb",
	]

	if Dir.exist? "bin"
		spec.executables =
			Dir.new("bin").entries - [ ".", ".." ]
	end

	spec.require_paths = [ "lib" ]

end
