class LogsController < ApplicationController
  before_filter :authorize_token!
  # Checks in a device on the specified location.
  #
  #   POST /logs.json
  #
  # ==== Parameters
  # * <b>device</b> - Device token for single notifications.
  # * <b>lat</b> - Latitude to target several devices.
  # * <b>lng</b> - Longitude to target several devices.
  #
  # ==== Returns
  #
  # A JSON representation of the logged device on success, an error otherwise.
  #
  def create
    @log = current_app.logs.create(params)
    render json: @log
  end 
end

