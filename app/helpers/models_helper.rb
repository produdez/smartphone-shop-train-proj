module ModelsHelper
  def format_description(des)
    des.present? ? des : 'No description'
  end
end
