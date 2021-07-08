class Color < ApplicationRecord
  has_many :phones

  validates :name, presence: true, uniqueness: true
end
