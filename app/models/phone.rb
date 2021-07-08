class Phone < ApplicationRecord
  belongs_to :model
  belongs_to :store
  belongs_to :color

  STATUSES = %w[in_stock unavailable].freeze
  enum status: STATUSES.zip(STATUSES).to_h

  validates :manufacture_year, :memory, :price, numericality: {greater_than_or_equal_to: 0}
  validates :condition, :status, presence: true
  validates :status, inclusion: {in: STATUSES}
  validates :condition, inclusion: {in: ['99%', 'Like New', 'Old', 'Used Once', 'Brand New', '98%', 'Decently New', 'Usable']}

end

