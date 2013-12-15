SourcedPartx::Engine.routes.draw do
  
  resources :parts do
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results    
    end
  end
  
  root :to => 'parts#index'
end
