ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %Q(<span class="field_with_errors">#{html_tag}</span>).html_safe

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css form_fields.join(', ')
  
  elements.each do |e|
    if form_fields.include? e.node_name
      if instance.error_message.kind_of?(Array)
        html = %Q(
          <span class="field_with_errors" data-container="body" data-toggle="popover" data-placement="top" data-content="#{instance.error_message.uniq.join(', ')}">
            #{html_tag}
          </span>
          ).html_safe
      else        
        html = %Q(
          <span class="field_with_errors" data-container="body" data-toggle="popover" data-placement="top" data-content="#{instance.error_message}">
            #{html_tag}
          </span>
          ).html_safe
      end
    end
  end
  html
end
