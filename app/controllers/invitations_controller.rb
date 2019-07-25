class InvitationsController < ApplicationController
  def index
    @pending_users = User.invitation_not_accepted
    @accepted_users = User.invitation_accepted
  end

  def resend
    @user = User.find(params[:id])
    @user.invite!
    flash[:notice] = "User Invitation Resent."
    redirect_back(fallback_location: root_path)
  end
end
