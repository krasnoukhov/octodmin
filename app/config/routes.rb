namespace "api" do
  resource  :version, only: [:show]
  resource  :site, only: [:show]
  resources :posts, only: [:index, :create, :show, :update]
end

mount Octodmin.sprockets, at: "/assets"

get "/", to: "frontend#index", as: :home
