class Category < ApplicationRecord

  has_many :devices, dependent: :destroy

  validates :name, presence: true, uniqueness: true

end
