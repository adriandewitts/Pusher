require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminDeviceNotifications
end

module RailsAdmin
  module Config
    module Actions
      class DeviceNotifications < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      
        register_instance_option :http_methods do
          [:get]
        end
        register_instance_option :visible? do        
          authorized? && bindings[:object].class.name == 'Device' rescue false
        end
        
        register_instance_option :object_level do
          true
        end
        
        # http://twitter.github.com/bootstrap/base-css.html#icons
        register_instance_option :link_icon do
          'icon-tasks'
        end        

        register_instance_option :route_fragment do
          'device_notifications'
        end
        register_instance_option :authorization_key do
          :device_notifications
        end
        register_instance_option :member do
          true
        end
        
        register_instance_option :controller do
          Proc.new do
            if request.get?
              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
              end
            end
          end
        end
      end
    end
  end
end


