class LoginActivitiesController < ApplicationController
  def index
    if current_user.admin?
      @login_activities = LoginActivity.all
    else
      @login_activities = LoginActivity.where(identity: current_user.email)
    end
  end
end
