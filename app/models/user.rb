class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :staff, dependent: :destroy
  ROLES = %w[admin user].freeze
  enum role: ROLES.zip(ROLES).to_h

  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: ROLES, message: 'User role can only be admin or user(normal)!' }
  validates :phone, format: { with: %r{\A[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]*\z|} } # phone regex from https://regexr.com/, notice empty is allowed
end
