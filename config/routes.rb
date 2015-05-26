SourcedPartx::Engine.routes.draw do
  
  resources :parts do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results    
    end
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('part_wf_route', 'sourced_partx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        patch :submit
        patch :manager_approve
        patch :manager_reject
        patch :vp_approve
        patch :vp_reject
        patch :vp_rewind
        patch :stamp
        patch :complete
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  root :to => 'parts#index'
end
