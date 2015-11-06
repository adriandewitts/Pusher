module Rapns
  module Daemon
    class Delivery     
      include Reflectable

      def self.perform(*args)
        new(*args).perform
      end

      def retry_after(notification, deliver_after)        
        notification.retries += 1
        notification.deliver_after = deliver_after
        notification.save!(:validate => false)        
        reflect(:notification_will_retry, notification)
      end

      def retry_exponentially(notification)
        retry_after(notification, Time.now + 2 ** (notification.retries + 1))
      end

      def mark_delivered        
        @notification.delivered = true
        @notification.delivered_at = Time.now
        @notification.save!(:validate => false)      
        reflect(:notification_delivered, @notification)
      end

      def mark_failed(code, description)        
        @notification.delivered = false
        @notification.delivered_at = nil
        @notification.failed = true
        @notification.failed_at = Time.now
        @notification.error_code = code
        @notification.error_description = description
        @notification.save!(:validate => false)        
        reflect(:notification_failed, @notification)
      end
    end
  end
end
