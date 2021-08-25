require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :questions, except: [:edit] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      member do
        post :mark_as_best
      end
    end

    resources :notifications, only: [:create, :destroy], shallow: true
  end

  resources :rewards, only: [:index]

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  concern :voteable do |options|
    member do
      resources :votes, { only: [:create] }.merge(options)
    end
  end

  resources :questions, only: [], param: :voteable_id do
    concerns :voteable, defaults: { voteable_type: 'question' }, as: :question_votes
  end

  resources :answers, only: [], param: :voteable_id do
    concerns :voteable, defaults: { voteable_type: 'answer' }, as: :answer_votes
  end

  resources :votes, only: [:destroy]

  concern :commentable do |options|
    member do
      resources :comments, { only: [:create] }.merge(options)
    end
  end

  resources :questions, only: [], param: :commentable_id do
    concerns :commentable, defaults: { commentable_type: 'question' }, as: :question_comments
  end

  resources :answers, only: [], param: :commentable_id do
    concerns :commentable, defaults: { commentable_type: 'answer' }, as: :answer_comments
  end

  get '/a/:enter_email_token/ee', to: 'authorizations#enter_email', as: :auth_enter_email
  post '/a/:enter_email_token/ue', to: 'authorizations#update_email', as: :auth_update_email
  get '/a/:confirm_email_token/ce', to: 'authorizations#confirm_email', as: :auth_confirm_email

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
