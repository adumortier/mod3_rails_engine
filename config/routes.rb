Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      
      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'business#revenue'
      end

      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      resources :merchants, except: [:new, :edit] do 
        resources :items, only: [:index]
      end

      resources :items, except: [:new, :edit] 

      get '/items/:item_id/merchant', to: 'merchants#show'
      
        
    end
  end
end