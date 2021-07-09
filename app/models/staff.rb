class Staff < ApplicationRecord
  belongs_to :store
  belongs_to :user, dependent: :destroy

  ROLES = %w[employee manager].freeze
  enum role: ROLES.zip(ROLES).to_h

  validates :role, presence: true, inclusion: { in: ROLES, message: 'Staff role can only be manager or employee!' }
  validate :validate_user_role
  validate :validate_single_store_per_manager

  after_destroy do
    store.destroy if manager?
  end

  def validate_user_role
    errors.add(:role, "Invalid user role: #{user.role} for a staff, must be a normal user") unless user.user?
  end

  def validate_single_store_per_manager
    if manager?
      conflict_manager = Staff.manager.find_by(store: store)
      errors.add(:store, 'Store already have a manager (1-1)') unless conflict_manager.nil?
    end
  end
end