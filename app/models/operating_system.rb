class OperatingSystem < ApplicationRecord
  has_many :models, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
