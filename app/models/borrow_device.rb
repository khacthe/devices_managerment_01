class BorrowDevice < ApplicationRecord

  after_initialize :set_defaults, unless: :persisted?

  enum borrow_status: [:reject, :waiting, :leader_accept, :borrowed, :return]

  has_many :borrow_items, dependent: :destroy

  belongs_to :user

  validates :borrow_date_from, presence: true
  validates :borrow_date_to, presence: true
  validates :status, presence: true,
    inclusion: {in: BorrowDevice.borrow_statuses.values}

  scope :find_by_user_id, -> user_id do
    BorrowDevice.where(user_id: user_id).order(created_at: :desc)
  end

  scope :list_borrowed_in_group, -> group_id do
    BorrowDevice.where(user_id: User.list_user_id_by_group(group_id))
      .order(created_at: :desc)
  end

  scope :list_borrowed_in_workspace, -> workspace_id do
    BorrowDevice.where(user_id: User.list_user_id_by_workspace(workspace_id))
      .order(created_at: :desc)
  end

  scope :get_all, -> do
    BorrowDevice.all.order(created_at: :desc)
  end

  scope :dealine_borrow, -> do
    where borrow_date_to: Date.today,
    status: BorrowDevice.borrow_statuses[:borrowed]
  end

  private
  def set_defaults
    self.borrow_type ||= false
  end

  def self.send_deline_borrow
    borrows = self.dealine_borrow
      if borrows
      borrows.each do |borrow|
        user = borrow.user
        UserMailer.send_email_deadline_to_user(user).deliver
      end
    end
  end
end
