class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable
         
  CODE_VALUES = [0..999]
  validates :name, presence: true, length: { maximum: 50 }
  validates :code, presence: true, inclusion: { in: CODE_VALUES }
end
