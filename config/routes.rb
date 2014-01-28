SourcedPartx::Engine.routes.draw do
  
  resources :parts do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results    
    end
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('part_wf_route', 'sourced_partx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :manager_approve
        put :manager_reject
        put :vp_approve
        put :vp_reject
        put :vp_rewind
        put :stamp
        put :complete
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  root :to => 'parts#index'
end
