module ApplicationHelper
  def model_names
    Model.all.map(&:name)
  end

  def color_names
    Color.all.map { |color| color.name.capitalize }
  end
end
