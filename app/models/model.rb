class Model < ApplicationRecord
  belongs_to :brand
  belongs_to :operating_system
  has_many :phones

  validates :name, presence: true, uniqueness: true
end
