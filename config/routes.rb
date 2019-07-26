Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  devise_for :users, :controllers => { registrations: 'users/registrations',
                                        invitations: 'users/invitations' }
  resources :users
  resources :invitations, only: [:index, :resend] do
    member do
      get :resend
    end
  end

  # mailbox folder routes
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash
  # conversations
  resources :conversations do
    resources :messages
    member do
      post :reply
      post :trash
      post :untrash
      post :add_participant
      post :opt_in
      post :opt_out
    end
  end

end
