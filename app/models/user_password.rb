class UserPassword < ApplicationRecord
  belongs_to :user
  belongs_to :password

  validates :role, presence: true, inclusion: { in: roles.keys }

  enum role: {
    owner: 'OWNER',
    viewer: 'VIEWER',
    editor: 'EDITOR',
    manager: 'MANAGER'
  }, scopes: true
end
