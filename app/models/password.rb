class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords, dependent: :destroy

  encrypts :username, deterministic: true # Allows for searching by username
  encrypts :password

  validates :service, :username, :password, presence: true

  def editable_by?(user)
    user_passwords.find_by(user: user)&.editable?
  end

  def sharable_by?(user)
    user_passwords.find_by(user: user)&.sharable?
  end

  def deletable_by?(user)
    user_passwords.find_by(user: user)&.deletable?
  end
end
