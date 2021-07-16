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
    raise StandardError 'Unspecified filter name!' unless filter_name.present?

    send("filter_by_#{filter_name}", **options)
  }

  scope :filter_by_brand, lambda { |value: nil|
    joins(model: :brand).where(brand: { id: value })
  }

  scope :filter_by_operating_system, lambda { |value: nil|
    joins(model: :operating_system).where(operating_system: { id: value })
  }

  scope :filter_by_color, lambda { |value: nil|
    joins(:color).where(color: { id: value })
  }

  scope :filter_by_store, lambda { |value: nil|
    joins(:store).where(store: { id: value })
  }

  scope :filter_by_model, lambda { |value: nil|
    joins(:model).where(model: { id: value })
  }

  scope :filter_by_condition, lambda { |value: nil|
    where(condition: value)
  }

  scope :filter_by_status, lambda { |value: nil|
    where(status: value)
  }

  scope :filter_by_manufacture_year_range, lambda { |min: nil, max: nil|
    where(GetRangeSqlService.call('manufacture_year', min, max))
  }

  scope :filter_by_memory_range, lambda { |min: nil, max: nil|
    where(GetRangeSqlService.call('memory', min, max))
  }

  scope :filter_by_price_range, lambda { |min: nil, max: nil|
    where(GetRangeSqlService.call('manufacture_year', min, max))
  }

  scope :filter_by_created_at_range, lambda { |min: nil, max: nil|
    # ! this one is special !
    where(GetRangeSqlService.call('created_at', min, max))
  }
end
