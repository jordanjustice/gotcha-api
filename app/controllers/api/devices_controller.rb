class API::DevicesController < ApplicationController
  before_action :require_authorization

  def create
    device = Device.find_by player_id: current_user.id, token: device_params[:token]
    if device.nil?
      device = Device.create! device_params.merge(player_id: current_user.id,
                                                  registered_at: DateTime.now)
      status = :created
    else
      status = :ok
    end

    render json: DeviceSerializer.new(device).serialized_json, status: status
  end

  def destroy
    device = Device.find_by_token! params[:id]
    device.destroy

    head :no_content
  end

  private

  def device_params
    params.require(:data)
          .require(:attributes)
          .permit(:token)
  end
end
