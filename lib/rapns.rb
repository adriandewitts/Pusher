require 'multi_json'
require 'rapns/multi_json_helper'
require 'rapns/configuration'
require 'rapns/reflection'
require 'rapns/embed'
require 'rapns/push'
module Rapns
  def self.require_for_daemon
    require 'rapns/daemon'
  end
end
