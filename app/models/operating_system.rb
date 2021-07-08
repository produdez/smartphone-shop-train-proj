class OperatingSystem < ApplicationRecord
  has_many :models

  validates :name, presence: true, uniqueness: true
end