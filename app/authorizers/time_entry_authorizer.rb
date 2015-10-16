class TimeEntryAuthorizer < ApplicationAuthorizer
  def readable_by?(user)
    resource.user_id == user.id
  end
  def updatable_by?(user)
    resource.user_id == user.id
  end
end