require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminNotify
end

module RailsAdmin
  module Config
    module Actions
      class Notify < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
      
        register_instance_option :http_methods do
          [:get, :post]
        end
        register_instance_option :visible? do        
          authorized? && bindings[:object].class.name == 'Device' rescue false
        end
        
        register_instance_option :object_level do
          true
        end
        
        # http://twitter.github.com/bootstrap/base-css.html#icons
        register_instance_option :link_icon do
          'icon-bell'
        end        

        register_instance_option :route_fragment do
          'notify'
        end
        register_instance_option :authorization_key do
          :notify
        end
        register_instance_option :member do
          true
        end
        
        register_instance_option :controller do
          Proc.new do
            if request.get?
              @last_notification = @object.app.notifications.last
              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
              end
            elsif request.post?              
              selected_devices = [@object.device]                           
              params[:notification][:devices] = selected_devices              
               @object.app.notifications.create(params[:notification])
              redirect_to back_or_index
            end
          end
        end
      end
    end
  end
end

