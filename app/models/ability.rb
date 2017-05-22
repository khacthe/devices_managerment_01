class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.has_role? :admin
      can :manage, :all
      cannot [:update], BorrowDevice
    elsif user.has_role? :bo
      can :manage, :all
      cannot [:read], BorrowDevice,
        {status: BorrowDevice.borrow_statuses[:waiting]}
      cannot [:update], BorrowDevice,
        {status: [BorrowDevice.borrow_statuses[:reject],
        BorrowDevice.borrow_statuses[:waiting],
        BorrowDevice.borrow_statuses[:return]]}
      cannot [:create], Device
    elsif user.has_role? :leader
      can [:read], BorrowDevice
      can [:update], BorrowDevice,
        {status: BorrowDevice.borrow_statuses[:waiting]}
      can [:read], Device
      can [:read, :update], User, {id: user.id}
    else user.has_role? :member
      can :read, Device
      can :read, BorrowDevice, {user_id: user.id}
      can [:update], BorrowDevice,
        {user_id: user.id, status: BorrowDevice.borrow_statuses[:waiting]}
      can :create, BorrowDevice
      can :manage, BorrowItem
      can [:read, :create], Message, {user_id: user.id}
      can [:read, :update], User, {id: user.id}
    end
  end
end
