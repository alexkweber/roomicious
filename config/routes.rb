Uberoommate::Application.routes.draw do
  resources :users, :photos, :postings
  root :to => "postings#index"
  
  match 'auth/:provider/callback', to: 'sessions#fbcreate'
  match 'auth/failure', to: redirect('/')
  
  controller :pages do
    get "about", :as => 'about'
    get "service", :as => 'service'
    get "contact", :as => 'contact'
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy, :as => 'logout'
  end
  
  match '/login' => 'sessions#new', :as => 'login'
  match '/logout' => 'sessions#destroy', :as => 'logout'
  match '/signup' => 'users#new', :as => 'signup'
end
