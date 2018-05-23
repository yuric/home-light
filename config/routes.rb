Rails.application.routes.draw do
  root to: "agents#random_agent"

  resources :agents do
    resources :uploaded_transactions do
      collection {post :import}
    end
  end
end
