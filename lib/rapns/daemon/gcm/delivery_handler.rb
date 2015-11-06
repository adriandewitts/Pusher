module Rapns
  module Daemon
    module Gcm
      class DeliveryHandler < Rapns::Daemon::DeliveryHandler
        def initialize(app)
          @app = app
          @http = Net::HTTP::Persistent.new('rapns')
        end

        def deliver(notification)
          Rapns::Daemon::Gcm::Delivery.perform(@app, @http, notification)
        end

        def stopped
          @http.shutdown
        end
      end
    end
  end
end
