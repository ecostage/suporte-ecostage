class Users::RegistrationsController < Devise::RegistrationsController
  
  def new
    if params.key?(:invite_token)
      invitation = Invitation.find_by_token(params[:invite_token])
      if invitation and not invitation.stale?
        @token = params[:invite_token]
        @user = invitation.user
        render 'devise/registrations/new_invited_user'
      else
        redirect_to new_user_session_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end
