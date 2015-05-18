Rails.application.routes.draw do

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => 'unauthenticated_user_root'
    end
  end

  devise_for :users, controllers: { registrations: "users/registrations" }

  patch "users/accept_invite"=>"users#accept_invite", as: :accept_invite

  authenticate :user do
    root to: "dashboards#show", :as => 'authenticated_user_root'

    resources :invitations, only: [:new, :create]

    get 'profile'=>'profiles#edit', as: :myprofile
    patch 'profile'=>'profiles#update'

    get 'metrics'=>'metrics#show', as: :metrics
    resources :users, only: [:index]

    resources :channels, only: [:update, :create, :destroy] do
      resources :tickets, module: 'channels' do
        post 'new_comment'
      end

      namespace :tickets, module: 'channels' do
        put ':id/approve'=>'tickets#approve', as: :approve
        put ':id/reprove'=>'tickets#reprove', as: :reprove
        put ':id/done'=>'tickets#done', as: :done
        put ':id/cancel'=>'tickets#cancel', as: :cancel
      end

      resources :members, defaults: { format: :json }, only: [:create, :destroy], module: 'channels'
    end

    resources :tickets, only: [] do
      post :assign_to, on: :member
    end

    get 'tickets/:id/download'=>'tickets#download', as: :ticket_attachment_download
    get 'comments/:id/download'=>'comments#download', as: :comment_attachment_download

    resources :groups, only: [:new, :create, :show] do
      member do
        post 'add_user'
        delete 'inactivate_member'
        post 'add_channel'
        delete 'channel/:channel_id' => 'groups#delete_channel', as: :delete_channel
      end
    end

    resource :dashboard, only: [:show]
  end

  if Rails.env.development?
    mount MailPreview => 'mail_preview'
  end
end
