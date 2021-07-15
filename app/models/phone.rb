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
  end
end
