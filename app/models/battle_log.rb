class BattleLog < ApplicationRecord
  belongs_to :player
  
  validates :enemy_name, presence: true
  validates :victory, inclusion: { in: [true, false] }
  validates :exp_gained, :player_level_before, :player_level_after, 
            numericality: { greater_than_or_equal_to: 0 }
  
  scope :victories, -> { where(victory: true) }
  scope :defeats, -> { where(victory: false) }
  scope :recent, -> { order(created_at: :desc) }
  
  def result_text
    victory? ? "勝利" : "敗北"
  end
  
  def result_class
    victory? ? "success" : "danger"
  end
end