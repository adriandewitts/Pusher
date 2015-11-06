class NotificationsController < ApplicationController
  before_filter :authorize_token!
  # Sends a push notification.
  #
  #   POST /notifications.json
  #
  # ==== Parameters
  # * <b>devices</b> - Array of device tokens.
  # * <b>tags</b> - <em>Optional</em>. A comma separated list of tags this notification will target.
  # * <b>badge</b> - <em>Optional</em>.
  # * <b>sound</b> - <em>Optional</em>.
  # * <b>alert</b> - <em>Optional</em>.
  # * <b>payload</b> - <em>Optional</em>. A hash of value/pairs with custom data to send along with the push.
  # * <b>send_at</b> - <em>Optional</em>. Send the notification on or shortly after this date.
  #
  # ==== Returns
  #
  # A JSON representation of the notification on success, an error otherwise.
  #
  def create
    @notification = current_app.notifications.create(params)
    render json: @notification
  end

  # Returns a JSON representation of the specified notification.
  #
  #   POST /notifications/:id.json
  #
  # ==== Returns
  #   { "id": "<value>", "alert": "<value>", "badge": <value>, "coords": { "lng": <value>, "lat": <value> },
  #     "payload": { ... }, "range": <value>, "send_at": "<value>", "sent_at": "<value>", "sound": "<value>",
  #     "tags": [ "<value>", ... ], "sent_count": <value> }
  #
  def show
    @notification = current_app.notifications.find(params[:id])
    render json: @notification
  end
end

