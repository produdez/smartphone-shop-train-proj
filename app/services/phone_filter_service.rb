class PhoneFilterService
  def self.call(filters)
    filters = filters.present? ? filters : {}
    phones = Phone
    filters.each do |name, options|
      options = options.to_h.symbolize_keys

      next if CheckEmptyHashService.call(options)

      phones = phones.filter_by(name, options)
    end

    phones.order(updated_at: :desc)
  end
end
