namespace "api" do
  resource  :version, only: [:show]
  resource  :site, only: [:show]
  resources :posts do
    member do
      patch :restore
      patch :revert
      post  :upload
    end
  end
  resources :syncs, only: [:create]
  resources :deploys, only: [:create]
end

if ENV["LOTUS_ENV"] != "production"
  mount Octodmin.sprockets, at: "/assets"
end

get "/posts*", to: "frontend#index"
get "/", to: "frontend#index", as: :home
