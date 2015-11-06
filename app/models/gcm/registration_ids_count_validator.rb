
module Gcm
  class RegistrationIdsCountValidator < ActiveModel::Validator
    LIMIT = 1000

    def validate(record)
      if record.devices && record.devices.size > LIMIT
        record.errors[:base] << "GCM notification num of registration_ids cannot be larger than #{LIMIT}."
      end
    end
  end
end

