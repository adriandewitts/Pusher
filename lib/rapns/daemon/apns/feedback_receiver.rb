module Rapns
  module Daemon
    module Apns
      class FeedbackReceiver
        include Reflectable
        include InterruptibleSleep
    
        FEEDBACK_TUPLE_BYTES = 38

        def initialize(app, host, port, poll)
          @app = app
          @host = host
          @port = port
          @poll = poll
          @certificate = app.apns_certificate
          @password = app.apns_key
        end

        def start
          @thread = Thread.new do
            loop do
              break if @stop
              check_for_feedback
              interruptible_sleep @poll
            end
          end
        end

        def stop
          @stop = true
          interrupt_sleep
          @thread.join if @thread
        end

        def check_for_feedback
          connection = nil
          begin
            connection = Connection.new(@app, @host, @port)
            connection.connect

            while tuple = connection.read(FEEDBACK_TUPLE_BYTES)
              timestamp, device_token = parse_tuple(tuple)
              create_feedback(timestamp, device_token)
            end
          rescue StandardError => e
            Rapns::Daemon.logger.error(e)
          ensure
            Rapns::Daemon.logger.info("[#{@app.name}] [FeedbackReceiver] connection closed.")
            connection.close if connection
            Rapns::Daemon.logger.info("[#{@app.name}] [FeedbackReceiver] connection closed.")
          end
        end

        protected
        
        def parse_tuple(tuple)
          failed_at, _, device_token = tuple.unpack("N1n1H*")
          [Time.at(failed_at).utc, device_token]
        end
        
        def create_feedback(failed_at, device_token)
          formatted_failed_at = failed_at.strftime("%Y-%m-%d %H:%M:%S UTC")    
          Rapns::Daemon.logger.info("[#{@app.name}] [FeedbackReceiver] Delivery failed at #{formatted_failed_at} for #{device_token}.")
          feedback = ::Apns::Feedback.create!(:failed_at => failed_at, :device => device_token, :app => @app)
          reflect(:apns_feedback, feedback)
        end
        
      end
    end
  end
end
