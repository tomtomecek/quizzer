require 'spec_helper'

describe MarkdownHelper do
  describe "#markdown" do
    it "returns an unordered list with list items" do
      text = "* line item\n* line item 2"
      expect(helper.markdown(text)).to match /<ul>.<li>.+<\/li>.<\/ul>/m
    end

    it "returns a paragraph" do
      text = "simple text"
      expect(helper.markdown(text)).to match /<p>.+<\/p>/m
    end

    it "returns ruby code inside pre tags" do
      text = "``` ruby\nputs 'Hello World'\n```"
      expect(helper.markdown(text)).to match /<pre>.+<\/pre>/m
    end

    context "HTML renderer level options" do
      it "hard wraps text returning <br> where md would not" do
        text = "Give me\nbreak"
        expect(helper.markdown(text)).to match /Give me<br>.break/m
      end

      it "filters html" do
        text = "<span>HTML code</span>"
        expect(helper.markdown(text)).to_not match /<span>.+<\/span>/m
      end
    end

    context "Markdown level options" do
      it "parses autolinks if not specified with <>" do
        text = "http://gotealeaf.com"
        expect(helper.markdown(text)).
          to match /<a href=\"http:\/\/gotealeaf.com\">.+<\/a>/m
      end

      it "camelcased words will not generate <em> tags" do
        text = "foo_bar_baz"
        expect(helper.markdown(text)).to match /foo_bar_baz/
      end

      it "uses PHPs fences code blocks" do
        text = "~~~ ruby\n def hello\nputs 'Hello'\nend\n~~~"
        expect(helper.markdown(text)).
          to match /<pre>.+class=\"k\">def.+<\/pre>/m
      end

      it "recognizes strikesthrough PHP markdown" do
        text = "this is ~~good~~ bad"
        expect(helper.markdown(text)).to match /this is <del>good<\/del> bad/
      end

      it "parses highlighted to <mark>" do
        text = "is ==highlighted=="
        expect(helper.markdown(text)).to match /is <mark>highlighted<\/mark>/m
      end

      it "recognizes superscript" do
        text = "tests 1^(st)"
        expect(helper.markdown(text)).to match /tests 1<sup>st<\/sup>/m
      end
    end

    context "syntax highlighting" do
      it "wraps markdown output with class highlighting" do
        text = "``` ruby\nputs 'Hello World'\n```"
        expect(helper.markdown(text)).to match /div class="highlight".+<\/div/m
      end
    end
  end
end
