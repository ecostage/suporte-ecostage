class ChannelsController < ApplicationController
  before_action :set_channel, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /channels
  def index
    @channels = Channel.all
    authorize(@channels)
    respond_with(@channels)
  end

  # GET /channels/1
  def show
    authorize(@channel)
    respond_with(@channel)
  end

  # GET /channels/new
  def new
    @channel = Channel.new
    authorize(@channel)
    respond_with(@channel)
  end

  # GET /channels/1/edit
  def edit
    authorize(@channel)
    respond_with(@channel)
  end

  # POST /channels
  def create
    @channel = Channel.new(channel_params)
    authorize(@channel)

    @channel.save
    respond_with(@channel) do |format|
      if @channel.persisted?
        format.html { redirect_to channel_tickets_path(@channel) }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /channels/1
  def update
    authorize(@channel)
    @channel.update(channel_params)
    respond_with(@channel)
  end

  # DELETE /channels/1
  def destroy
    @channel.destroy
    authorize(@channel)
    respond_with(@channel)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = Channel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def channel_params
      params.require(:channel).permit(:name, :purpose, member_ids: [])
    end
end
