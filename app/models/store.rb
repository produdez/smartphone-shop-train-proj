# frozen_string_literal: true

class Store < ApplicationRecord
  has_many :phones, dependent: :destroy
  has_many :staffs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
