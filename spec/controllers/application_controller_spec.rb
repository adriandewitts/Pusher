require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render json: { status: 'ok' }
    end
  end  
end

