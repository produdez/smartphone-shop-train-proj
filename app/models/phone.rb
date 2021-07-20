class Phone < ApplicationRecord
  belongs_to :model
  belongs_to :store
  belongs_to :color

  STATUSES = %w[in_stock unavailable].freeze
  CONDITIONS = %w[percent99 like_new old used_once brand_new percent98 decent_new usable].freeze
  enum status: STATUSES.zip(STATUSES).to_h
  enum condition: CONDITIONS.zip(CONDITIONS).to_h

  validates :manufacture_year, :memory, :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :condition, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :condition, inclusion: { in: CONDITIONS }

  scope :filter_by, lambda { |filter_name, **options|
    raise PhoneFilterService::NilFilterNameError if filter_name.blank?

    send("filter_by_#{filter_name}", **options)
  }

  scope :filter_by_brand, lambda { |value: nil|
    joins(:model).where(model: { brand_id: value })
  }

  scope :filter_by_operating_system, lambda { |value: nil|
    joins(:model).where(model: { operating_system_id: value })
  }

  scope :filter_by_color, lambda { |value: nil|
    where(color_id: value)
  }

  scope :filter_by_store, lambda { |value: nil|
    where(store_id: value)
  }

  scope :filter_by_model, lambda { |value: nil|
    where(model_id: value)
  }

  scope :filter_by_condition, lambda { |value: nil|
    where(condition: value)
  }

  scope :filter_by_status, lambda { |value: nil|
    where(status: value)
  }

  scope :filter_by_manufacture_year_range, lambda { |min: nil, max: nil|
    where(PhoneFilterService.get_range_sql('manufacture_year', min, max))
  }

  scope :filter_by_memory_range, lambda { |min: nil, max: nil|
    where(PhoneFilterService.get_range_sql('memory', min, max))
  }

  scope :filter_by_price_range, lambda { |min: nil, max: nil|
    where(PhoneFilterService.get_range_sql('manufacture_year', min, max))
  }

  scope :filter_by_created_at_range, lambda { |start_date: nil, end_date: nil|
    # !This query is very dangerous! due to datetime type and also created_at column being in all tables
    start_time = PhoneFilterService.convert_params_to_datetime(start_date)
    end_time = PhoneFilterService.convert_params_to_datetime(end_date, start: false)

    return where('phones.created_at BETWEEN ? AND ?', start_time, end_time) if start_time.present? && end_time.present?

    return where('phones.created_at >= ?', start_time) if start_time.present?

    where('phones.created_at <= ?', end_time) if end_time.present?
  }
end
