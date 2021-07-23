# frozen_string_literal: true

class Ability # rubocop:todo Style/Documentation
  include CanCan::Ability

  # rubocop:todo Metrics/MethodLength
  def initialize(user) # rubocop:todo Metrics/AbcSize
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
      cannot :create, Phone
      cannot :new_employee, User
      cannot :create_employee, User
    else
      can :read, User, id: user.id
      staff = user.staff
      if staff.employee?
        can :read, Phone, store_id: staff.store_id
        can :read, Brand
        can :read, OperatingSystem
        can :read, Model
      elsif staff.manager?
        can :manage, Phone, store_id: staff.store_id
        can :read, Brand
        can :read, OperatingSystem
        can :read, Model
        can :create_employee, User
        can :new_employee, User
        can :read, User, staff: { store: { id: user.staff.store_id } }
      end
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
  # rubocop:enable Metrics/MethodLength
end
