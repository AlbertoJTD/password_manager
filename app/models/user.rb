class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :trackable, :confirmable

  has_many :user_passwords, dependent: :destroy
  has_many :passwords, through: :user_passwords, dependent: :destroy
  has_many :invitees, class_name: 'User', foreign_key: 'invited_by_id'
end
