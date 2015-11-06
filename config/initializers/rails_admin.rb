# RailsAdmin config file. Generated on January 18, 2013 13:38
# See github.com/sferik/rails_admin for more informations
require 'rails_admin_notify'
require 'rails_admin_device_notifications'

RailsAdmin.config do |config|
   config.actions do
      dashboard
      index
      new
      bulk_delete
      notify      
      device_notifications
      show
      edit
      delete
    end


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Pusher', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated
  config.authorize_with :cancan
  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = ['Notification', 'App']

  # Include specific models (exclude the others):
  # config.included_models = ['App', 'Device', 'Notification']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:
 
  config.model 'User' do    
    edit do
      field :email
      field :password
      field :password_confirmation
      field :admin
      field :android_apps
      field :ios_apps
      field :groups
    end
  end
  
  config.model 'Apns::App' do
    visible do
       bindings[:controller].current_user.admin?
    end
    
    navigation_label 'iOS'
    label 'iOS App'
    list do
      field :name      
      field :device_count
      field :connections
      field :enabled      
      field :user
      field :updated_at
      field :access_token      
    end
    edit do
      field :name
      field :apns_certificate
      field :certificate_expired_at, :date do
        help false
      end
      field :apns_key
      field :apns_gateway     
      field :enabled
      field :connections
          
      field :user    
    end    
  end
  
   config.model 'Gcm::App' do
     
    visible do      
      bindings[:controller].current_user.admin?
    end
    
     navigation_label 'Android'
     label 'Android App'
     
    list do
      field :name      
      field :device_count
      field :connections
      field :enabled      
      field :user
      field :updated_at
      field :access_token      
    end
    edit do
      field :name
      field :auth_key
      field :enabled     
      field :connections
      field :user          
    end    
  end 
   
  config.model 'Apns::Feedback' do
    visible do
    user = bindings[:controller].current_user
    user.admin? 
  end
    navigation_label 'iOS'
    label 'Feedback'
  end

  list_fields = [:app, :alert, :deliver_after, :delivered_at, :error_description]
  show_fields = [:app, :alert, :deliver_after, :delivered_at, :tags, :failed_at, :error_code, :error_description]
  edit_fields = [:app, :alert, :deliver_after, :tags]

  config.model 'Apns::Notification' do
   
    visible do
      user = bindings[:controller].current_user
      user.admin? 
    end
  
    navigation_label 'iOS'
    label 'iOS Notification'

    show{
      show_fields.each{|f| field f}
      field :devices
    }

    list{
      list_fields.each{|f| field f}   
    }
    
    edit{
      edit_fields.each{|f| field f}
    }    
  end

  config.model 'Gcm::Notification' do
    
    visible do
      user = bindings[:controller].current_user       
      user.admin? # || !user.android_app_ids.blank? 
    end
    
    label 'Android Notification'
    navigation_label 'Android'

    show{
      show_fields.each{|f| field f}
      field :devices     
    }

    list{
      list_fields.each{|f| field f}
    }

    edit{
        edit_fields.each{|f| field f}        
    }
  end

  config.model 'Device' do
     weight -1  
     configure :device, :text 
     configure :enabled, :boolean 
     configure :tags, :serialized
     configure :app
     list do
        [:updated_at, :device, :enabled,:app].each{|f| field(f)}
        sort_by :updated_at
        sort_reverse true 
     end   
  end

  config.model GroupNotification do
    navigation_label ''
    label 'Notification'

    list{
      show_fields.reject{|f| f == :app}.each{|f| field f}
      #field :notification_ids
    }
    
    edit{
      field :group
      edit_fields.reject{|f| f == :app}.each{|f| field f}                
    } 
  end
  
  config.model Group do
    visible do      
      bindings[:controller].current_user.admin?
    end
    navigation_label 'Group'
    configure :group_notifications do
      visible(false)
    end
  end
end
