class ConversationsController < ApplicationController
  before_action :set_participant, only: [:add_participant, :opt_in, :opt_out]
  before_action :set_opted_out_participants, only: [:show, :add_participant, :opt_out]

  def show
    unless conversation.is_participant?(current_user)
      flash[:alert] = "You do not have permission to view that conversation."
      return redirect_to root_path
    end
    @users = User.all
    @receipts = conversation.receipts_for(current_user)
    @opted_in = conversation.has_subscriber?(current_user)

    # mark conversation as read
    conversation.mark_as_read(current_user)
  end

  def new
    disabled_users = User.where(disabled: true)
    deleted_users = User.where.not(deleted_at: nil)
    patients = User.joins(:user_type).where(user_types: {name: 'Patient'})
    if current_user.user_type.name == "Patient"
      @users = User.where.not(id: current_user) - patients - disabled_users - deleted_users
    else
      @users = User.where.not(id: current_user) - disabled_users - deleted_users
    end
    @subject = params[:subject]
    if params[:recipient]
      @recipient = User.find(params[:recipient])
    end
  end

  def create
    recipients = User.where(id: conversation_params[:recipients])
    conversation = current_user.send_message(recipients, conversation_params[:body], conversation_params[:subject]).conversation
    flash[:success] = "Your message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def reply
    current_user.reply_to_conversation(conversation, message_params[:body])
    flash[:notice] = "Your reply message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def add_participant
    if conversation.participants.include? @participant
      flash[:notice] = "#{@participant.name} already a participant."
      redirect_to conversation_path(conversation)
    elsif @opted_out_participants.include? @participant
      flash[:notice] = "Participant is opted out"
      redirect_to conversation_path(conversation)
    elsif conversation.add_participant(@participant)
      @system_message = "#{@participant.name} added to this conversation."
      @participant.reply_to_conversation(conversation, @system_message)
      redirect_to conversation_path(conversation)
    end
  end

  def opt_in
    if conversation.participants.include? @participant
      flash[:notice] = "Participant already opted in"
      redirect_to conversation_path(conversation)
    elsif conversation.opt_in(@participant)
      @system_message = "#{@participant.name} opted in."
      @participant.reply_to_conversation(conversation, @system_message)
      redirect_back(fallback_location: conversations_path)
    end
  end

  def opt_out
    if @opted_out_participants.include? @participant
      flash[:notice] = "Participant already opted out"
      redirect_to conversation_path(conversation)
    elsif conversation.opt_out(@participant)
      @system_message = "#{@participant.name} opted out."
      current_user.reply_to_conversation(conversation, @system_message)
      redirect_back(fallback_location: conversations_path)
    end
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to mailbox_inbox_path
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to mailbox_inbox_path
  end

  private
    def set_participant
      @participant = User.find(params[:participant])
    end

    def set_opted_out_participants
      # get list of opted out participants
      opt_out_ids = conversation.opt_outs.pluck(:unsubscriber_id)
      @opted_out_participants = User.where(id: opt_out_ids)
    end

    def conversation_params
      params.require(:conversation).permit(:subject, :body,recipients:[])
    end

    def message_params
      params.require(:message).permit(:body, :subject)
    end
end
