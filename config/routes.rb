Rails.application.routes.draw do
  root 'game#index'
  
  # ゲーム関連
  get '/game', to: 'game#index'
  post '/game/create_player', to: 'game#create_player'
  
  # プレイヤー関連
  resources :players, only: [:show] do
    member do
      get :status
      post :rest
      post :start_battle
      post :attack
      post :flee
      delete :reset  # プレイヤーリセット機能追加
    end
  end
  
  # 管理者用（開発時のみ）
  if Rails.env.development?
    get '/admin/reset_all', to: 'admin#reset_all'
    post '/admin/reset_confirm', to: 'admin#reset_confirm'
  end
end
