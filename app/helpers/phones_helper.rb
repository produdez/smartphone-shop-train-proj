module PhonesHelper
  def format_price(price)
    number_to_currency(price, unit: '$')
  end

  def format_memory(memory)
    number_to_human(memory, precision: 2, units: { mili: 'MB', unit: 'GB', thousand: 'TB' })
  end

  def color_mapping
    Color.all.collect { |color| [color.name.capitalize, color.id] }
  end

  def model_mapping
    Model.all.collect { |model| [model.name, model.id] }
  end

  def status_mapping
    Phone::STATUSES.collect { |status| [status.capitalize, status] }
  end

  def in_stock
    Phone::STATUSES[0]
  end

  def in_stock_status_mapping
    [['In Stock', in_stock]]
  end

  def year_mapping
    2010..2025
  end

  def condition_mapping
    [
      ['99%', 'percent99'],
      ['Like New', 'like_new'],
      %w[Old old],
      ['Used Once', 'used_once'],
      ['Brand New', 'brand_new'],
      ['98%', 'percent98'],
      ['Decently New', 'decent_new'],
      %w[Usable usable]
    ]
  end
end
