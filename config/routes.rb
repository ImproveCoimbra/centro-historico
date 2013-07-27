Centro::Application.routes.draw do

  resources :buildings

  match 'about' => 'front#about'
  match 'resources' => 'front#resources'
  root :to => 'front#index'
end
