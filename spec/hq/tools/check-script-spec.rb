require "hq/tools/check-script"

module HQ
module Tools

describe CheckScript do

	before do
		subject.stub(:process_args)
		subject.stub(:perform_checks)
		subject.stdout = StringIO.new
	end

	context "status" do

		it "critical" do
			subject.stub(:perform_checks) do
				subject.critical "critical"
				subject.warning "warning"
				subject.unknown "unknown"
				subject.message "ok"
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed CRITICAL: critical, warning, unknown, ok\n"
			subject.status.should == 2
		end

		it "warning" do
			subject.stub(:perform_checks) do
				subject.warning "warning"
				subject.unknown "unknown"
				subject.message "ok"
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed WARNING: warning, unknown, ok\n"
			subject.status.should == 1
		end

		it "unknown" do
			subject.stub(:perform_checks) do
				subject.unknown "unknown"
				subject.message "ok"
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed UNKNOWN: unknown, ok\n"
			subject.status.should == 3
		end

		it "ok" do
			subject.stub(:perform_checks) do
				subject.message "ok"
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: ok\n"
			subject.status.should == 0
		end

	end

	context "performance data" do

		it "none" do
			subject.stub(:perform_checks) do
				subject.message "hello"
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello\n"
		end

		it "single metric" do
			subject.stub(:perform_checks) do
				subject.message "hello"
				subject.performance "metric1", 1
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello | metric1=1\n"
		end

		it "apostrophe" do
			subject.stub(:perform_checks) do
				subject.message "hello"
				subject.performance "apos'trophe", 1
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello | 'apos''trophe'=1\n"
		end

		it "whitespace" do
			subject.stub(:perform_checks) do
				subject.message "hello"
				subject.performance "white space", 1
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello | 'white space'=1\n"
		end

		it "optional fields" do
			subject.stub(:perform_checks) do
				subject.message "hello"
				subject.performance \
					"metric1",
					1,
					:units => "blops",
					:warning => 2,
					:critical => 5,
					:minimum => 0,
					:maximum => 10
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello | metric1=1blops;2;5;0;10\n"
		end

		it "two metrics" do
			subject.stub(:perform_checks) do
				subject.message "hello"
				subject.performance "metric1", 1
				subject.performance "metric2", 5
			end
			subject.main
			subject.stdout.string.should ==
				"Unnamed OK: hello | metric1=1 metric2=5\n"
		end

	end

end

end
end
