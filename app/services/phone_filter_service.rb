class PhoneFilterService
  class PhoneFilterError < StandardError; end

  class NilFilterNameError < PhoneFilterError
    def message
      'No filter name specified'
    end
  end

  def initialize(filters)
    @filters = filters.present? ? filters : {}
  end

  def filter
    filters = @filters
    phones = Phone
    filters.each do |name, options|
      options = options.to_h.symbolize_keys

      next if check_empty_hash(options)

      phones = phones.filter_by(name, options)
    end

    phones.order(updated_at: :desc)
  end

  def self.get_range_sql(attribute_name, min, max)
    return "#{attribute_name} BETWEEN #{min} AND #{max}" if min.present? && max.present?

    return "#{attribute_name} <= #{max}" if min.empty?

    return "#{attribute_name} >= #{min}" if max.empty?

    nil
  end

  private

  def check_empty_hash(options)
    options.reduce(true) { |empty, (_key, val)| empty && val.empty? }
  end
end
