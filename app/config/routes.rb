namespace "api" do
  resource  :version, only: [:show]
  resources :posts, only: [:index]
end

get "/", to: "frontend#index", as: :home
