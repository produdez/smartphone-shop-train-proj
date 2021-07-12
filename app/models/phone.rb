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
end
