module ApplicationHelper

  def nav_link(path = nil, options = nil, &block)
    li_options = current_page?(path) ? { class: "active" } : {}
    content_tag(:li, li_options) do
      link_to(path, options, &block)
    end
  end

end
