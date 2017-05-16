class Message < ApplicationRecord

  enum message_status: [:waiting, :processing, :done]

  belongs_to :user

  validates :messages, presence: true
  validates :status, presence: true,
    inclusion: {in: Message.message_statuses.values}

  scope :workspace_messages, -> user_id do where(sendtoid: user_id)
  end
end
