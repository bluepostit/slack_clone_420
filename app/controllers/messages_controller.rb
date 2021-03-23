class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.user = current_user
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message.chatroom = @chatroom

    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: { message: @message })
      )
      notify_other_users
      redirect_to chatroom_path(@chatroom, anchor: "message-#{@message.id}")
    else
      render 'chatroom/show'
    end
  end

  private

  def notify_other_users
    users = User.all - [current_user]
    users.each do |user|
      NotificationChannel.broadcast_to(
        user,
        "A new message!"
      )
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
