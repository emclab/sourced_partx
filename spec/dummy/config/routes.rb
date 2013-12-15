Rails.application.routes.draw do

  mount SourcedPartx::Engine => "/sourced_partx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Kustomerx::Engine => '/customerx'
  mount HeavyMachineryProjectx::Engine => '/projectx'
  mount SrcPlantx::Engine => '/src_plantx'
  mount Searchx::Engine => '/searchx'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
