module ApplicationHelper
  include MarkdownHelper
  include LinkedInHelper

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

  def passing_percentage_array
    arr = 0.step(100, 5).to_a
    arr.map { |n| ["#{n} %", n] }
  end

  def roles
    ['Teaching assistant', 'Instructor']
  end

  def instructors_select_options
    Admin.instructors.map { |a| [a.username, a.id] }
  end

  def pretty_percentage(percentage, options = {})
    if options[:display]
      percentage == 100 ? "Completed" : "#{percentage}%"
    else
      "#{percentage}%"
    end
  end
end
