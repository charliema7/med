class Users::InvitationsController < Devise::InvitationsController
  # before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    super
  end

  def after_invite_path_for(resource)
    invitations_path
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name])
      devise_parameter_sanitizer.permit(:invite, keys: [:user_type_id])
    end
end