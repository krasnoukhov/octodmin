namespace "api" do
  resource  :version, only: [:show]
  resource  :site, only: [:show]
  resources :posts, only: [:index, :create, :show]
end

sprockets = Sprockets::Environment.new
sprockets.append_path "app/assets/stylesheets"
sprockets.append_path "app/assets/javascripts"
sprockets.register_engine ".cjsx", CjsxProcessor
mount sprockets, at: "/assets"

get "/", to: "frontend#index", as: :home
