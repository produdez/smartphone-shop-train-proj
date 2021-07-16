class GetRangeSqlService
  def self.call(attribute_name, min, max)
    return "#{attribute_name} BETWEEN #{min} AND #{max}" if min.present? && max.present?

    return "#{attribute_name} <= #{max}" if min.empty?

    return "#{attribute_name} >= #{min}" if max.empty?

    nil
  end
end
