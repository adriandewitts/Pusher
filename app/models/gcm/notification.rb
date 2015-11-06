module Gcm
    class Notification < Notification
         
      belongs_to :app, class_name: 'Gcm::App'
            
      validates_with Gcm::ExpiryCollapseKeyMutualInclusionValidator
      validates_with Gcm::PayloadDataSizeValidator
      validates_with Gcm::RegistrationIdsCountValidator
            
      def as_json(options = {})
        data = (payload || {}).dup
        data['alert'] = self.alert
        json = {
          'registration_ids' => devices,
          'delay_while_idle' => delay_while_idle,
          'data' => data
        }

        if collapse_key
          json.merge!({
            'collapse_key' => collapse_key,
            'time_to_live' => expiry
          })
        end

        json
      end

      def packed_message_data_size
        multi_json_dump(as_json['data']).bytesize
      end
    end
end

