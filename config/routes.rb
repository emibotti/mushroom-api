Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :organizations,  only: %i[create show]

  get '/organization_code', to: 'organizations#organization_code'
  post '/join_organization', to: 'organizations#join_organization'
  
  resources :rooms, only: [:index, :show, :create] do
    post :create_inspection, on: :member
  end

  resources :mycelia do
    collection do
      get :options
      post :harvest
    end

    member do
      get :weight_required
      put :archive
      put :ready_toggle
    end

    resources :inspections
  end

end
