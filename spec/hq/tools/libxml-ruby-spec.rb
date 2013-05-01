require "xml"

require "hq/tools/libxml-ruby"

module HQ
module Tools

describe LibXmlRuby do

	subject { Class.new { include LibXmlRuby }.new }

	context "xml_to_data" do

		def test xml
		end

		def self.it_converts xml, expect
			it "converts #{xml} to #{expect}" do
				doc = XML::Document.string xml
				actual = subject.xml_to_data doc.root
				actual.should === expect
			end
		end

		it_converts "<boolean value=\"yes\"/>", true
		it_converts "<boolean value=\"no\"/>", false
		it_converts "<boolean value=\"\"/>", false
		it_converts "<boolean/>", false

	end

end

end
end
