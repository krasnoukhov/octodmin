resources :posts, only: [:index]
resource  :version, only: [:show]
get "/", to: "frontend#index", as: :home
