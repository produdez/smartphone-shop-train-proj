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

  attr_reader :filters

  def filter
    phones = Phone.includes(:color, :store, :model, model: %i[brand operating_system])
    filters.each do |name, options|
      options = options.to_h.symbolize_keys

      next if UtilityHelper.check_empty_hash(options)

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

  def self.convert_params_to_datetime(event, start: true)
    return nil if UtilityHelper.check_empty_hash(event)

    today = Date.today
    year = event['dates(1i)']
    year = year.present? ? year.to_i : today.year
    month = event['dates(2i)']
    month = month.present? ? month.to_i : today.month
    day = event['dates(3i)']
    day = day.present? ? day.to_i : today.day

    date = Date.new(year, month, day)
    start ? date.beginning_of_day : date.end_of_day
  end
end
