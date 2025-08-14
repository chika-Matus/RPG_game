class GameController < ApplicationController
  def index
    if current_player
      redirect_to player_path(current_player)
    else
      # 新しいプレイヤー作成フォームを表示
      @player = Player.new
      render :index
    end
  end
  
  def create_player
    @player = Player.new(player_params)
    
    # 初期ステータス設定
    @player.assign_attributes(
      hp: 100,
      max_hp: 100,
      attack: 15,
      defense: 5,
      exp: 0,
      exp_to_next: 100
    )
    
    if @player.save
      session[:player_id] = @player.id
      redirect_to player_path(@player), notice: "#{@player.name}よ、冒険の始まりだ！"
    else
      render :index, status: :unprocessable_entity
    end
  end
  
  private
  
  def player_params
    params.require(:player).permit(:name)
  end
end