class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :team
  has_many :requests
  has_many :messages, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :derby_name, presence: true

  mount_uploader :photo, PhotoUploader
end
