Rails.application.routes.draw do
    root 'wishlist#index'
    get  'fulfilled', to: 'wishlist#fulfilled'

    match '/404', to: 'errors#file_not_found', via: :all
    match '/422', to: 'errors#unprocessable', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all

    resources :settings, only: [] do
        collection do
            get  :edit
            post :update
            post :validate_newsnab_key
            post :validate_sabnzbd_key
        end
    end

    resources :wish, only: [:create, :update, :destroy] do
        resources :results, only: [:index], controller: :wish_results do
            member do
                post 'send_to_sabnzbd'
                get  'download'
            end
        end
    end

    resources :categories, only: [:index]

    resources :queue, only: [:index] do
        post :action, on: :collection
    end
end
