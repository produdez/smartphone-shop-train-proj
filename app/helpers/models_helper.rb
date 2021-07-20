# frozen_string_literal: true

module ModelsHelper # rubocop:todo Style/Documentation
  def format_description(des)
    des.present? ? des : 'No description'
  end
end
