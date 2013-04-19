require "hq/tools/cron"

module HQ
module Tools

describe Cron do

	context "#wrap" do

		it "calls the provided block" do
			called = false
			subject.wrap do
				called = true
			end
			called.should == true
		end

	end

end

end
end
