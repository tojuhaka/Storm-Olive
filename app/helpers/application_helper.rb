module ApplicationHelper
  def title
    base_title = "Storm Olive, the greatest blog-site ever seen!"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
