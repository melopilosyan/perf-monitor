Rails.application.routes.draw do

  resources :tests, only: [:index, :create] do
    get 'last', on: :collection
  end
end
