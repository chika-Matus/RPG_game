class GameSession < ApplicationRecord
  belongs_to :player
  
  validates :in_battle, inclusion: { in: [true, false] }
  
  # デフォルト値をモデル側で設定
  after_initialize :set_defaults
  
  def add_to_log(message)
    self.battle_log = (self.battle_log || "") + "#{message}\n"
  end
  
  def clear_log
    self.battle_log = ""
  end
  
  def start_battle(enemy_data)
    self.in_battle = true
    self.current_enemy = enemy_data
    clear_log
    add_to_log("#{enemy_data['description']}")
    add_to_log("野生の#{enemy_data['name']}が現れた！")
  end
  
  def end_battle
    self.in_battle = false
    self.current_enemy = {}
  end
  
  def current_enemy
    super || {}
  end
  
  private
  
  def set_defaults
    self.battle_log ||= ""
    self.current_enemy ||= {}
  end
end