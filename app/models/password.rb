class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords, dependent: :destroy

  encrypts :username, deterministic: true # Allows for searching by username
  encrypts :password

  validates :service, :username, :password, presence: true
end
