class GroupsController < ApplicationController
  respond_to :html, :json
  before_action :find_group, except: [:new, :create]

  def new
    @group = Group.new
    authorize @group
    respond_with(@group)
  end

  def update
    authorize @group
    @group.update(group_params)
    respond_with(@group)
  end

  def create
    @group = Group.create(group_params)
    authorize @group
    respond_with(@group)
  end

  def show
    authorize @group
    respond_with(@group)
  end

  def add_user
    authorize @group, :update?

    if @group.invite(params[:email], current_user)
      render invite_user_with_success_message(params[:email])
    else
      render invited_user_error_message(params[:email])
    end
  end

  def inactivate_member
    authorize @group, :edit?
    @user = User.find params[:member_id]
    @user.inactive!
    render :json=>@user.to_json
  end

  def add_channel
    authorize @group, :update?
    unless @group.channel_ids.include? params[:channel_id]
      @group.channels << Channel.find(params[:channel_id])
    end
    respond_with(@group)
  end

  def delete_channel
    authorize @group, :update?
    GroupChannel
      .find_by(group_id: @group.id, channel_id: params[:channel_id])
      .destroy
    respond_with(@group)
  end

  private

  def find_group
    @group ||= Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :purpose, member_ids: [],
                                  channel_ids: [])
  end

  def invite_user_with_success_message(email)
    {  text: t('invitation.flash_messages.success', email: email) }
  end

  def invited_user_error_message(email)
    { text: I18n.t('invitation.flash_messages.invited_user', email: email) }
  end
end
