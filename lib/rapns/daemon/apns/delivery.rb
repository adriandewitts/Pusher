module Rapns
  module Daemon
    module Apns
      class Delivery < Rapns::Daemon::Delivery
        SELECT_TIMEOUT = 0.2
        ERROR_TUPLE_BYTES = 6
        FAILS_SAFE_FLAG = "/tmp/rapns_apn_stop.txt"
        APN_ERRORS = {
          1 => "Processing error",
          2 => "Missing device token",
          3 => "Missing topic",
          4 => "Missing payload",
          5 => "Missing token size",
          6 => "Missing topic size",
          7 => "Missing payload size",
          8 => "Invalid token",
          255 => "None (unknown error)"
        }

        def initialize(app, conneciton, notification)
          @app = app
          @connection = conneciton
          @notification = notification
        end

        def perform
          begin
            @notification.touch
          rescue Exception => ex
            #Cannot connect the database
            return 
          end          
          return if failsafe?
            invalid_devices = []
            delivered = false
            (@notification.devices || []).each do |device|
              begin
                @connection.write(@notification.to_binary(device))
                check_for_error if Rapns.config.check_for_errors
                delivered = true
              rescue Rapns::DeliveryError, Rapns::Apns::DisconnectionError => error
                if error.code.to_i == 8
                  invalid_devices << device
                else
                  mark_failed(error.code, error.description)
                  raise  
                end              
              end
            end
          
         begin
            if delivered
              mark_delivered
              Rapns::Daemon.logger.info("[#{@app.name}] #{@notification.id} sent to #{@notification.devices.inspect}")              
            else
              @notification.reload
              mark_failed(-1, "Unknown errors") unless @notification.failed
              Airbrake.notify_or_ignore(Exception.new("Notification was not set as delivered: #{@notification.id}")) if defined?(Airbrake)
            end
          rescue Exception => ex
            failsafe!
            Airbrake.notify_or_ignore(ex) if defined?(Airbrake)
            Airbrake.notify_or_ignore(Exception.new("Stop sending push messages!")) if defined?(Airbrake)            
          end
          
          unless invalid_devices.blank?           
            Device.in(device: invalid_devices).update_all(enabled: false)
            Airbrake.notify_or_ignore(Exception.new("Invalid device tokens: #{invalid_devices.inspect}")) if defined?(Airbrake)
            mark_failed(8, "Invalid device tokens: #{invalid_devices.inspect}")
          end
          
        end

        protected
        
        def failsafe?
          File.exists?(FAILS_SAFE_FLAG)
        end
        
        def failsafe!
          FileUtils.touch(FAILS_SAFE_FLAG)
        end
        def check_for_error
          if @connection.select(SELECT_TIMEOUT)
            error = nil

            if tuple = @connection.read(ERROR_TUPLE_BYTES)
              cmd, code, notification_id = tuple.unpack("ccN")

              description = APN_ERRORS[code.to_i] || "Unknown error. Possible rapns bug?"
              error = Rapns::DeliveryError.new(code, notification_id, description)
            else
              error = Rapns::Apns::DisconnectionError.new
            end

            begin
              Rapns::Daemon.logger.error("[#{@app.name}] Error received, reconnecting...")
              @connection.reconnect
            ensure
              raise error if error
            end
          end
        end
      end
    end
  end
end
