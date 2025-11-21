module ApplicationHelper
  def render_markdown(text)
    Kramdown::Document.new(text, input: 'GFM', syntax_highlighter: "rouge").to_html
  end

  def page_body_class
    "#{controller_name}-#{action_name}"
  end
end
