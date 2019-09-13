Rails.application.routes.draw do
  resources :songs

  get '/', to: 'index#index'
  get '/bot/start', to: 'bot#start'
  get '/bot/kill', to: 'bot#kill'
end
