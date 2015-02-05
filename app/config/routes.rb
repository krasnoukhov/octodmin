namespace "api" do
  resource  :version, only: [:show]
  resource  :site, only: [:show]
  resources :posts do
    member do
      patch :restore
    end
  end
  resources :syncs, only: [:create]
end

if ENV["LOTUS_ENV"] != "production"
  mount Octodmin.sprockets, at: "/assets"
end

get "/posts*", to: "frontend#index"
get "/", to: "frontend#index", as: :home
