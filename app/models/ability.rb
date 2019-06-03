class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    if user.present? && user.admin?
      admin_abilities
    elsif user.present? && user.reviewer?
      reviewer_abilities
    elsif user.present?
      contributer_abilities
    else
      visitor_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def reviewer_abilities
    contributer_abilities
    can :review, Gesture
    can :index_unreviewed, Gesture
  end

  def contributer_abilities
    visitor_abilities
    can :create, Gesture
    can :show, User
    can :contributions, User
  end

  def visitor_abilities
    can :read, Category
    can :read, Word
    can :autocomplete, Word
    can :index_recently_added, Gesture
  end
end
