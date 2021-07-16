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

  class << self
    def filter_by(filter_name, options = {})
      if !filter_name || options.empty?
        nil # TODO: may raise error?
      else
        send("filter_by_#{filter_name}", *options)
      end
    end

    private

    def filter_by_brand_name(value = nil)
      joins(model: :brand).where(brand: {name: value})
    end

    def filter_by_os_name(value = nil)
      joins(model: :operating_system).where(operating_system: {name: value})
    end

    def filter_by_color_name(value = nil)
      joins(:color).where(color: {name: value})
    end

    def filter_by_store_name(value = nil)
      joins(:store).where(store: {name: value})
    end

    def filter_by_condition(value = nil)
      where(condition: value)
    end

    def filter_by_manufacture_year_range(min = nil, max = nil)
      where(range_sql_str('manufacture_year', min, max))
    end

    def filter_by_memory_range(min = nil, max = nil)
      where(range_sql_str('memory', min, max))
    end

    def filter_by_price_range(min = nil, max = nil)
      where(range_sql_str('manufacture_year', min, max))
    end

    def filter_by_created_at_range(min = nil, max = nil)
      # ! this one is special !
      where(range_sql_str('created_at', min, max))
    end
  end
end

# TODO: move this helper to helper or module!
def range_sql_str(attribute_name, min = nil, max = nil)
  return "#{attribute_name} BETWEEN #{min} AND #{max}" if min.present? && max.present?

  return "#{attribute_name} <= #{max}" if min.nil?

  return "#{attribute_name} >= #{min}" if max.nil?

  nil
end
