module Mongoid::AutoCoords
  def self.included(base)
    base.before_validation {
      self.coords = [@lat, @lng] if @lat.present? && @lng.present?
    }

    def lat=(value)
      @lat = value
      coords ||= []
      coords[0] = @lat
      @lat
    end

    def lng=(value)
      @lng = value
      coords ||= []
      coords[1] = @lng
      @lng
    end

    def lat
      coords[0] || @lat
    end

    def lng
      coords[1] || @lng
    end
  end
end


