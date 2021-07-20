module UtilityHelper
  def check_empty_hash(options)
    return true if options.blank?

    options = options.to_unsafe_h if options.is_a?(ActionController::Parameters)
    options.reduce(true) { |empty, (_key, val)| empty && val.empty? }
  end

  module_function :check_empty_hash
end
