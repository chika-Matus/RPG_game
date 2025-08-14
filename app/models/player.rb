class Player < ApplicationRecord
  has_many :battle_logs, dependent: :destroy
  has_one :game_session, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :level, :hp, :max_hp, :attack, :defense, :exp_to_next, presence: true
  validates :level, :hp, :max_hp, :attack, :defense, :exp, :exp_to_next, :battle_count, 
            numericality: { greater_than_or_equal_to: 0 }
  
  after_create :create_game_session
  
  # ... 既存のメソッドは変更なし ...
  
  private
  
  def create_game_session
    # GameSessionの作成時にデフォルト値が自動設定される
    GameSession.create!(player: self)
  end
end