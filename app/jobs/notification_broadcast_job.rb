class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform notification
    ActionCable.server.broadcast "notification_channel",
      user_id: notification.user_id,
      notification: notification.notifications,
      link: notification.link,
      id: notification.id,
      activity: notification.activity
  end
end
