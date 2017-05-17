class Notification < ApplicationRecord

  after_create_commit {NotificationBroadcastJob.perform_later self}
  after_initialize :set_defaults, unless: :persisted?

  belongs_to :user

  validates :activity, presence: true
  validates :notifications, presence: true

  scope :default_load {order(created_at: :desc)}
  scope :num_not_check, ->{where(checked: false).count}
  scope :notification_not_checked, ->{where(checked: false)}

  private
  def set_defaults
    self.read ||= false
    self.checked ||= false
  end

end
