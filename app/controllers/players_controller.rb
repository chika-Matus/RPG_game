# app/controllers/players_controller.rb
class PlayersController < ApplicationController
  before_action :require_player
  before_action :set_player
  before_action :set_game_session
  
  def show
    @recent_battles = @player.battle_logs.recent.limit(5)
  end
  
  def status
    render :status
  end
  
  def rest
    if @player.hp == @player.max_hp
      redirect_to player_path(@player), alert: "HPは既に満タンです！"
      return
    end
    
    heal_amount = @player.rest
    @player.save!
    
    redirect_to player_path(@player), 
                notice: "ゆっくりと休息を取りました。HP が #{heal_amount} 回復しました！"
  end
  
  def start_battle
    unless @player.alive?
      redirect_to player_path(@player), alert: "HPが0です。まずは休息を取りましょう。"
      return
    end
    
    enemy_template = Enemy.random_for_player(@player)
    enemy_data = enemy_template.generate_instance(@player.level)
    
    @game_session.start_battle(enemy_data)
    @game_session.save!
    
    @player.increment!(:battle_count)
    
    redirect_to player_path(@player), notice: "戦闘開始！"
  end
  
  def attack
    unless @game_session.in_battle?
      redirect_to player_path(@player), alert: "戦闘中ではありません。"
      return
    end
    
    enemy_data = @game_session.current_enemy
    
    # プレイヤーの攻撃
    attack_result = @player.attack_enemy(enemy_data)
    
    if attack_result[:critical]
      @game_session.add_to_log("💥 クリティカルヒット！")
    end
    @game_session.add_to_log("#{@player.name}の攻撃！ #{enemy_data['name']}に#{attack_result[:damage]}のダメージ！")
    
    if attack_result[:enemy_defeated]
      # 勝利処理
      victory(enemy_data)
    else
      # 敵の攻撃
      enemy_attack(enemy_data)
    end
    
    @game_session.current_enemy = enemy_data
    @game_session.save!
    @player.save!
    
    redirect_to player_path(@player)
  end
  
  def flee
    unless @game_session.in_battle?
      redirect_to player_path(@player), alert: "戦闘中ではありません。"
      return
    end
    
    if rand(100) < 70  # 70%の確率で逃走成功
      @game_session.add_to_log("💨 逃走成功！")
      @game_session.end_battle
      @game_session.save!
      
      redirect_to player_path(@player), notice: "戦闘から逃走しました。"
    else
      @game_session.add_to_log("💦 逃走に失敗した！")
      
      # 敵の攻撃のみ
      enemy_data = @game_session.current_enemy
      enemy_attack(enemy_data)
      
      @game_session.current_enemy = enemy_data
      @game_session.save!
      @player.save!
      
      redirect_to player_path(@player), alert: "逃走に失敗しました！"
    end
  end
  
  private
  
  def set_player
    @player = current_player
  end
  
  def set_game_session
    @game_session = @player.game_session
  end
  
  def victory(enemy_data)
    @game_session.add_to_log("🎉 勝利！")
    @game_session.add_to_log("#{enemy_data['name']}を倒した！")
    @game_session.add_to_log("#{enemy_data['exp_reward']}の経験値を獲得！")
    
    # 経験値獲得とレベルアップ
    level_before = @player.level
    level_result = @player.gain_exp(enemy_data['exp_reward'])
    
    level_result[:details].each do |detail|
      @game_session.add_to_log("🎉 レベルアップ！ Lv.#{detail[:new_level] - 1} → Lv.#{detail[:new_level]}")
      @game_session.add_to_log("HP+#{detail[:hp_increase]}, 攻撃力+#{detail[:attack_increase]}, 防御力+#{detail[:defense_increase]}")
    end
    
    # アイテムドロップ
    if rand(100) < 30  # 30%の確率
      heal_amount = rand(20..40)
      @player.heal(heal_amount)
      @game_session.add_to_log("🧪 薬草を見つけた！ HP が #{heal_amount} 回復！")
    end
    
    # バトルログ記録
    BattleLog.create!(
      player: @player,
      enemy_name: enemy_data['name'],
      victory: true,
      exp_gained: enemy_data['exp_reward'],
      player_level_before: level_before,
      player_level_after: @player.level,
      battle_summary: @game_session.battle_log
    )
    
    @game_session.end_battle
  end
  
  def enemy_attack(enemy_data)
    base_damage = enemy_data['attack'] + rand(1..10)
    critical = base_damage > enemy_data['attack'] + 7
    actual_damage = @player.take_damage(base_damage)
    
    if critical
      @game_session.add_to_log("💥 #{enemy_data['name']}のクリティカルヒット！")
    end
    @game_session.add_to_log("#{enemy_data['name']}の攻撃！ #{@player.name}に#{actual_damage}のダメージ！")
    
    unless @player.alive?
      defeat(enemy_data)
    end
  end
  
  def defeat(enemy_data)
    @game_session.add_to_log("💀 敗北...")
    @game_session.add_to_log("#{@player.name}は力尽きた...")
    @game_session.add_to_log("でも冒険はまだ続く！HPを回復して再挑戦しよう！")
    
    # バトルログ記録
    BattleLog.create!(
      player: @player,
      enemy_name: enemy_data['name'],
      victory: false,
      exp_gained: 0,
      player_level_before: @player.level,
      player_level_after: @player.level,
      battle_summary: @game_session.battle_log
    )
    
    @player.hp = 1  # 完全に0にはしない
    @game_session.end_battle
  end
end