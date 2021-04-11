Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions, except: [:edit] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :rewards, only: [:index]

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
end
