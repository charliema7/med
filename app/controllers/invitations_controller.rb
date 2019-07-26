class InvitationsController < ApplicationController
  def index
    if current_user.admin?
      @pending_users = User.invitation_not_accepted
      @accepted_users = User.invitation_accepted
    else
      @pending_users = current_user.invitations.where(invitation_accepted_at: nil).where.not(invitation_token: nil)
      @accepted_users = current_user.invitations.where.not(invitation_accepted_at: nil)
    end
  end

  def resend
    @user = User.find(params[:id])
    @user.invite!
    flash[:notice] = "User Invitation Resent."
    redirect_back(fallback_location: root_path)
  end
end
