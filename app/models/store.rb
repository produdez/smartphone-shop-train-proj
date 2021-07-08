class Store < ApplicationRecord
  belongs_to :user
  has_many :phones

  validates :name, presence: true, uniqueness: true
  validate :validate_manager_role

  def validate_manager_role
    if !user.manager?
      errors.add(:role , "Invalid user role: #{user.role} for an employee")
    end
  end
end
