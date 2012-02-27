class UsersController < ApplicationController

  hobo_user_controller
  
  auto_actions :all
  
  def edit
    hobo_show do
      hobo_ajax_response if request.xhr?
    end
  end
  
  def do_reset_password 
    do_transition_action :reset_password do
      redirect_to(:controller => "users", :action => "index")
    end
  end
    
end
