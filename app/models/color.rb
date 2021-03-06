# frozen_string_literal: true

class Color < ApplicationRecord
  has_many :phones, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
