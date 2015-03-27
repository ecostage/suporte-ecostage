class TicketsController < ApplicationController
  respond_to :json

  def index
    @tickets = Ticket.all
    respond_with(@tickets)
  end

  def assign_to
    if not current_user.client?
      @ticket = Ticket.find(params[:id])
      @ticket.update(params_ticket)
      Notification.create(notifiable: @ticket, created_by: current_user, action: :assigned).
        deliver

      render json: { assign_to: @ticket.assign_to.email }.to_json
    else
      render json: 'Unauthorized', status: 403
    end
  end

  def download
    @ticket = Ticket.find(params[:id])
    authorize @ticket, :download?
    redirect_to @ticket.attachment.expiring_url(10)
  end

  private

  def params_ticket
    { assign_to_id: params[:attendant_id] }
  end
end
