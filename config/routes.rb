Centro::Application.routes.draw do

  resources :buildings

  match 'about' => 'front#about'
  root :to => 'front#index'
end
