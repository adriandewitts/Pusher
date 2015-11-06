
module Apns
  class DeviceTokenFormatValidator < ActiveModel::Validator
    def validate(record)
      record.devices && record.devices.each do |device|
        if device !~ /^[a-z0-9]{64}$/
          record.errors[:devices] << "is invalid"
          break
        end
      end
    end
  end
end
