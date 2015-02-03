namespace "api" do
  resource  :version, only: [:show]
  resource  :site, only: [:show]
  resources :posts
  resources :syncs, only: [:create]
end

if ENV["LOTUS_ENV"] != "production"
  mount Octodmin.sprockets, at: "/assets"
end

get "/", to: "frontend#index", as: :home
