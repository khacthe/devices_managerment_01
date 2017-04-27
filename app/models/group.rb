class Group < ApplicationRecord

  has_many :users, dependent: :destroy

  belongs_to :workspace

  validates :name, presence: true, uniqueness: true

end
