
  module Gcm
    class PayloadDataSizeValidator < ActiveModel::Validator
      LIMIT = 4096

      def validate(record)
        if record.packed_message_data_size > LIMIT
          record.errors[:base] << "GCM notification payload data cannot be larger than #{LIMIT} bytes."
        end
      end
    end
  end

