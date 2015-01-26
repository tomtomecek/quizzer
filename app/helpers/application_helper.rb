module ApplicationHelper
  def github_sign_in_path
    "/auth/github"
  end

  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.send(association).build
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render "#{association.to_s.singularize}_fields", f: builder
    end
    plus_icon = content_tag(:span, '', class: "glyphicon glyphicon-plus-sign")
    link_to(
      '',
      class: "add_fields #{options[:class]}",
      data: { id: id, fields: fields.gsub("\n", "") }) do
        plus_icon + " " + name
    end
  end
end
