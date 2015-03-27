class Channels::MembersController < ApplicationController
  before_action :set_channel
  before_action :set_user, only: [:create]
  respond_to :json

  def create
    @channel_member = @channel.new_member(@user)
    respond_with(@channel, member: @user)
  end

  def destroy
    ChannelMember.destroy params[:id]
  end

  private

    def set_channel
      @channel = Channel.find params[:channel_id]
    end

    def set_user
      @user = User.find params[:user_id]
    end
end
