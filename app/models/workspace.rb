class Workspace < ApplicationRecord

  has_many :groups, dependent: :destroy
  has_many :devices, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :phone, presence: true

end
