module MarkdownHelper
  def markdown(content)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true, # not sure whether this works
      strikethrough: true,
      highlight: true,
      superscript: true
    }
    preserve do
      Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end
  end
end
