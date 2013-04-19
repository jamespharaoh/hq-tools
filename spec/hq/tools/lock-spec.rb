require "tmpdir"

require "hq/tools/lock"

module HQ
module Tools
describe Lock do

context "#lock" do

	before do
		@old_dir = Dir.pwd
		@temp_dir = Dir.mktmpdir
		Dir.chdir @temp_dir
	end

	it "calls the provided block" do
		called = false
		subject.lock "lockfile" do
			called = true
		end
		called.should == true
	end

	after do
		Dir.chdir @old_dir
	end

end

end
end
end
