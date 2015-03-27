class UsersController < ApplicationController
  respond_to :json, :html
  include Devise::Controllers::Helpers

  def index
    @clients = if params[:filter_text]
      User.client.where('email LIKE ?', "%#{params[:filter_text]}%")
    else
      User.client
    end
    respond_with @clients
  end

  def accept_invite
    if params.key? :invited_user_token
      invitation = Invitation.find_by_token(params[:invited_user_token])
      if invitation and not invitation.stale?
        @user = invitation.user
        if @user.update(user_params)
          @user.active!
          invitation.update(stale: true)
          sign_in(User, @user)
          respond_with @user, location: dashboard_path
        else
          redirect_to "#{new_user_registration_path}?invite_token=#{invitation.token}"
        end
      else
        redirect_to new_user_session_path
      end
    else
      super
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
