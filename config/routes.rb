Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :payments, :only => [] do
    collection do
      post :attempt_payment
    end
  end
end
