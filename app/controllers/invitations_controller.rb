class InvitationsController < ApplicationController
  respond_to :html

  def new
    @invitation = Invitation.new
  end

  def create
    email = params[:email]
    if current_user.invite({email: email})
      flash[:success] = success_invitation_message(email)
    else
      flash[:error] = invited_user_error_message(email)
    end

    redirect_to new_invitation_path
  end

  private
  
  def success_invitation_message(email)
    I18n.t('invitation.flash_messages.success', email: email)
  end

  def invited_user_error_message(email)
    I18n.t('invitation.flash_messages.invited_user', email: email)
  end

  def invited_existent_user_error_message
    I18n.t('invitation.flash_messages.existent_user')
  end
end
