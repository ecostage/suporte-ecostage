class ProfilesController < ApplicationController
  respond_to :html, :json

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(profile_params)
    flash[:success] = 'Perfil atualizado com sucesso'
    respond_to do |format|
      format.html { redirect_to myprofile_path }
      format.json
    end
  end

  private
  def profile_params
    params.require(:user).permit(:name, :avatar)
  end
end
