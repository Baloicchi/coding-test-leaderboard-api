Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/auth/user' => 'application#authorize_request'

  get '/user' => 'users#index'
  get '/user/:_id' => 'users#show'
  post '/user' => 'users#create'

  get '/leaderboard/:_id' => 'leaderboards#index'
  put '/leaderboard/:_id/user/:user_id/add_score' => 'leaderboards#add_score'
  post '/admin/leaderboard' => 'leaderboards#create'

  post '/entry' => 'entries#create'
end
