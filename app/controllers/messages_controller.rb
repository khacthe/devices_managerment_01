class MessagesController < ApplicationController
  before_action :authenticate_user!

  before_action :find_message, only: [:update, :show]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new message_params
    @message.user_id = current_user.id
    @workspace = current_user.group.workspace
    @message.sendtoid = @workspace.users
      .get_manager(User.user_positions[:bo])[0]["id"]
    if @message.save
      create_notification
      flash[:info] = t "users.create_success"
      redirect_to messages_path
    else
      render :new
    end
  end

  def index
    @messages = Message.workspace_messages(current_user.id)
  end

  def update
    if @message.update_attributes message_params
      Notification.create( user_id: @message.user_id,
        activity: t("messages.update"),
        notifications: t("messages.workspace_update"), link: "")
      flash[:success] = t "messages.update_mess_success"
      redirect_to messages_path
    else
      flash[:alert] = t "messages.update_mess_error"
      render :edit
    end
  end

  private

  def message_params
    params.require(:message).permit :title, :messages, :status
  end

  def create_notification
    @workspace = current_user.group.workspace
    @workspace.users.get_manager(2).each do |user|
      Notification.create( user_id: user.id, activity: t("messages.message"),
        notifications: "#{current_user.username} #{t("messages.send_message")}",
        link: "#{messages_path}")
    end
  end

  def find_message
    @message = Message.find_by_id params[:id]
    return if @message
    flash[:alert] = "message.not_find_message"
    redirect_to root_path
  end
end
