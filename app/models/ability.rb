class Ability
  include CanCan::Ability

  def initialize(user) 
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
     if user.admin?
       can :manage, :all     
     else      
       can :read, Apns::App, :id.in => user.ios_app_ids
       can :read, Gcm::App,:id.in => user.android_app_ids
       can :read, Group, :id.in => user.group_ids
       can :manage,GroupNotification, :group_id.in => user.group_ids
       can :manage, Apns::Notification, :app_id.in => user.ios_app_ids
       can :manage, Gcm::Notification, :app_id.in => user.android_app_ids       
     end
     
  end
end
