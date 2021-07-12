module PhonesHelper
  def format_price(price)
    number_to_currency(price, unit: '$')
  end

  def format_memory(memory)
    number_to_human(memory, precision: 2, units: {mili: 'MB', unit: 'GB', thousand: 'TB' })
  end
end
