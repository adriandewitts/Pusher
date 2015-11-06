class DevicesController < ApplicationController
  before_filter :authorize_token!
#  respond_to :json

  # Sets or updates a device preferences.
  #
  #   POST /devices.json
  #
  # ==== Parameters
  # * <b>device</b> - Device token.
  # * <b>enabled</b> - <em>Optional</em>. If '0', device won't be sent push notifications.
  # * <b>tags</b> - <em>Optional</em>. A comma separated list of tags this device wants to receive notifications from.
  #
  # ==== Returns
  #
  # A JSON representation of the device on success, an error otherwise.
  #
  def create
    @device = current_app.devices.find_or_create_by(device: params[:device])
    @device.update_attributes(params)
    render json: @device, location: nil
    #respond_with @device, location: nil
  end

  # Add/remove tags from device
  #
  #   POST devices/update_tags_in_device.json
  #
  # ==== Parameters
  # * <b>device</b> - Device token.
  # * <b>enabled</b> - <em>Optional</em>. If '0', device won't be sent push notifications.
  # * <b>tags</b> - <em>Optional</em>. A comma separated list of tags this device wants to receive notifications from.
  #
  # ==== Returns
  #
  # A JSON representation of the device on success, an error otherwise.
  #
  def update_tags_in_device
    tags = params[:tags].to_s.split(",")

    if params[:enabled].to_s == "true" || params[:enabled].to_s == "1"
      @device = current_app.devices.find_or_initialize_by(device: params[:device])
      @device.enabled = true

      @device.tags ||= []
      @device.tags += tags
      @device.tags.uniq!

      @device.save
    elsif @device = current_app.devices.where(device: params[:device]).first

      @device.tags = (@device.tags || []) - tags

      @device.save
    else
      render json: {error: "Device token can not be found"}, location: nil      
      return
    end

    render json: @device, location: nil
  end

  # Check the devices status
  #
  #   POST devices/devices_status.json
  #
  # ==== Parameters
  # * <b>devices</b> - A comma separated list of Devices token.
  # * <b>tags</b> - <em>Optional</em>. A comma separated list of tags a device wants to receive notifications from.
  #
  # ==== Returns
  #
  # A JSON representation of the devices status, an error otherwise.
  # return_data = {
  #   devices_enabled: @devices_enabled.join(","),
  #   devices_disabled: @devices_disabled.join(",")
  # }
  #
  def devices_status

    devices_token = if params[:devices].is_a?(Array)
                params[:devices]
              else
                params[:devices].split(",").map(&:strip)
              end

    #@devices_enabled = current_app.devices.enabled.in(device: devices_token).pluck(:device)
    
    @devices_disabled = current_app.devices.disabled.in(device: devices_token).pluck(:device)

    @devices_enabled = devices_token - @devices_disabled

    return_data = {
      devices_enabled: @devices_enabled.join(","),
      devices_disabled: @devices_disabled.join(",")
    }

    render json: return_data, location: nil
  end
end
  
