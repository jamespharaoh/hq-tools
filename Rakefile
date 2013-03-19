require "rspec/core/rake_task"
require "cucumber/rake/task"

desc "Run all tests"
task :default => [ :spec ]

desc "Run specs"
RSpec::Core::RakeTask.new :spec do
	|task|

	task.pattern = "spec/**/*-spec.rb"

	task.rspec_opts = [

		"--format progress",

		"--format html",
		"--out results/rspec.html",

		"--format RspecJunitFormatter",
		"--out results/rspec.xml",

	].join " "

	task.ruby_opts = [
		"-I lib",
	].join " "

end
