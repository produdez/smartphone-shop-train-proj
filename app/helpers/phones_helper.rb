# frozen_string_literal: true

module PhonesHelper # rubocop:todo Style/Documentation
  def color_mapping
    Color.all.collect { |color| [color.name.capitalize, color.id] }
  end

  def model_mapping
    Model.all.collect { |model| [model.name, model.id] }
  end

  def status_mapping
    Phone::STATUSES.collect { |status| [format_status(status), status] }
  end

  def in_stock
    Phone::STATUSES[0]
  end

  def in_stock_status_mapping
    [['In Stock', in_stock]]
  end

  def manufacture_year_mapping
    (2010..2025).to_a
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

  def format_price(price)
    number_to_currency(price, unit: '$')
  end

  def format_memory(memory)
    number_to_human(memory, precision: 4, units: { mili: 'MB', unit: 'GB', thousand: 'TB' })
  end

  def format_color(color)
    color.capitalize
  end

  def format_condition(condition_value)
    condition_mapping.find { |_text, value| value == condition_value }[0]
  end

  def format_status(status)
    status = status.dup
    status.gsub('_', ' ').capitalize
  end

  def format_model_description(phone)
    description = phone.model.description
    description.present? ? description : 'No description'
  end

  def format_note(phone)
    note = phone.note
    note.present? ? note : 'Note Empty'
  end

  def get_filtered_option(filter_name, field_type)
    params.dig(:filters, filter_name, field_type)
  end

  def get_filtered_date(filter_name, field_type) # rubocop:todo Metrics/AbcSize
    event = params.dig(:filters, filter_name, field_type)
    return nil if check_empty_hash(event)

    today = Date.today
    year = event['dates(1i)']
    year = year.present? ? year.to_i : today.year
    month = event['dates(2i)']
    month = month.present? ? month.to_i : today.month
    day = event['dates(3i)']
    day = day.present? ? day.to_i : today.day

    Date.new(year, month, day)
  end
end
