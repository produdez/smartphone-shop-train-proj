module PhonesHelper
  def format_price(price)
    number_to_currency(price, unit: '$')
  end

  def format_memory(memory)
    number_to_human(memory, precision: 2, units: { mili: 'MB', unit: 'GB', thousand: 'TB' })
  end

  def condition_strs
    puts Phone::CONDITIONS
    Phone::CONDITIONS.map { |cond| CONDITION_MAPPING[cond.to_sym] }
  end

  def get_condition_value(cond_str)
    CONDITION_MAPPING.each do |value, str|
      return value if str == cond_str
    end
  end

  # NOTE: %w[percent99 like_new old used_once brand_new percent98 decent_new usable].freeze
  CONDITION_MAPPING = {
    percent99: '99%',
    like_new: 'Like New',
    old: 'Old',
    used_once: 'Used Once',
    brand_new: 'Brand New',
    percent98: '98%',
    decent_new: 'Decently New',
    usable: 'Usable'
  }.freeze
end
