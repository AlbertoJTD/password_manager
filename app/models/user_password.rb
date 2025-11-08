class UserPassword < ApplicationRecord
  belongs_to :user
  belongs_to :password

  enum :role, {
    viewer: 'VIEWER',
    editor: 'EDITOR',
    owner: 'OWNER',
    manager: 'MANAGER'
  }, default: :viewer, scopes: true

  validates :role, presence: true, inclusion: { in: UserPassword.roles.keys }

  def editable?
    owner? || editor? || manager?
  end

  def sharable?
    owner?
  end

  def deletable?
    owner?
  end
end
