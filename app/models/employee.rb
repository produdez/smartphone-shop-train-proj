class Employee < ApplicationRecord
  belongs_to :store
  belongs_to :user, dependent: :delete

  validate :validate_employee_role

  def validate_employee_role
    if !user.employee?
      errors.add(:role , "Invalid user role: #{user.role} for an employee")
    end
  end
end
