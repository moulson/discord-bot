Rails.application.routes.draw do
  resources :songs

  get '/', to: 'index#index'
  get '/bot/run', to: 'bot#run'
  get '/bot/start', to: 'bot#start'
end
