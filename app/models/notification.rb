class Notification < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  belongs_to :user

  validates :activity, presence: true
  validates :notifications, presence: true

  private
  def set_defaults
    self.read ||= false
    self.checked ||= false
  end

end
